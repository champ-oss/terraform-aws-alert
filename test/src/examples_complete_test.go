package test

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
	"time"
)

// GetAWSSession Logs in to AWS and return a session
func GetAWSSession() *session.Session {
	fmt.Println("Getting AWS Session")
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		panic(err)
	}
	return sess
}

func GetLogs(session *session.Session, region string, logGroup string, logStream *string) []*cloudwatchlogs.OutputLogEvent {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.GetLogEventsInput{
		LogGroupName:  aws.String(logGroup),
		LogStreamName: aws.String(*logStream),
	}
	resp, _ := svc.GetLogEvents(params)

	// Pretty-print the response data.
	fmt.Println(resp)
	return resp.Events
}

func GetLogStream(session *session.Session, region string, logGroup string) *string {

	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.DescribeLogStreamsInput{
		LogGroupName: aws.String(logGroup),
		Descending:   aws.Bool(true),
		OrderBy:      aws.String("LastEventTime"),
	}

	resp, _ := svc.DescribeLogStreams(params)

	stream := resp.LogStreams[0].LogStreamName

	// Pretty-print the response data.
	fmt.Println(resp)
	return stream
}

func createLogEvent(session *session.Session, region string) {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	logGroupName := "terraform-aws-alert/test"
	logStreamName := "ecs/this/my-log-stream"
	logStreamInput := cloudwatchlogs.CreateLogStreamInput{LogGroupName: &logGroupName, LogStreamName: &logStreamName}
	_, _ = svc.CreateLogStream(&logStreamInput)

	logEvents := make([]*cloudwatchlogs.InputLogEvent, 0)

	logEvents = append(logEvents, &cloudwatchlogs.InputLogEvent{
		Message:   aws.String("2022-03-27 03:33:17.998 ERROR 7 --- [           main] o.s.a.r.l.SimpleMessageListenerContainer : Consumer failed to start in 60000 milliseconds"),
		Timestamp: aws.Int64(time.Now().UnixNano() / int64(time.Millisecond)),
	})

	p := cloudwatchlogs.PutLogEventsInput{LogEvents: logEvents, LogGroupName: &logGroupName, LogStreamName: &logStreamName}
	resp, err := svc.PutLogEvents(&p)
	if err != nil {
		panic(err)
	}
	fmt.Print("Next Token: {}", resp.NextSequenceToken)
}

func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	region := "us-east-1"
	slackUrl := os.Getenv("SLACK_URL")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",

		Vars: map[string]interface{}{
			// We also can see how lists and maps translate between terratest and terraform.
			"slack_url": slackUrl,
			"region":    region,
		},

		// Disable colors to parse stdout/stderr
		NoColor: true,
	})
	defer terraform.Destroy(t, terraformOptions)

	// Variables to pass to our Terraform code using -var options
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	logger.Log(t, "Creating AWS Session")
	awsSess := GetAWSSession()

	createLogEvent(awsSess, region)
	time.Sleep(30 * time.Second)

	// get lambda tf output logGroupName
	cloudwatchLogGroup := terraform.Output(t, terraformOptions, "cloudwatch_log_group")

	actualLogStreamName := GetLogStream(awsSess, region, cloudwatchLogGroup)
	fmt.Print(actualLogStreamName)

	logger.Log(t, "getting logs")
	outputLogs := GetLogs(awsSess, region, cloudwatchLogGroup, actualLogStreamName)

	logger.Log(t, "checking logs for ERROR")
	assert.NotContains(t, "ERROR", *outputLogs[1].Message)

	logger.Log(t, "checking message in log stream for expected value")
	expectedResponse := "{'status_code': 200, 'response': 'ok'}\n"
	assert.Contains(t, expectedResponse, *outputLogs[1].Message)
}
