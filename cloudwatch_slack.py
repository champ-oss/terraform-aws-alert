import json
import re
import os
import boto3
import urllib3
import gzip
import base64

# Lambda global variables
slack_url = os.environ["SLACK_URL"]
region = os.environ["REGION"]

http = urllib3.PoolManager()


def lambda_handler(event, context):
    url = slack_url

    encoded_zipped_data = event['awslogs']['data']
    zipped_data = base64.b64decode(encoded_zipped_data)
    uncompressed_payload = gzip.decompress(zipped_data)
    payload = json.loads(uncompressed_payload)

    for logEvent in payload['logEvents']:
        log_group_name = payload['logGroup']
        log_stream_name = payload['logStream']
        log_group_escaped = log_group_name.replace('/', '$252F')
        log_stream_escaped = log_stream_name.replace('/', '$252F')
        log_timestamp_start = str(logEvent['timestamp'])
        log_timestamp_endtime = str(logEvent['timestamp'] + 60000)
        msg = {
            "blocks": [
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": payload['logGroup'] + ":  ERROR reported",
                    }
                },
                {
                    "type": "rich_text",
                    "elements": [
                        {
                            "type": "rich_text_list",
                            "style": "bullet",
                            "elements": [
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Time: "
                                        },
                                        {
                                            "type": "text",
                                            "text": logEvent['timestamp'],
                                        }
                                    ]
                                },
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Account: "
                                        },
                                        {
                                            "type": "text",
                                            "text": payload['owner']
                                        }
                                    ]
                                },
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Log Group: "
                                        },
                                        {
                                            "type": "text",
                                            "text": payload['logGroup']
                                        }
                                    ]
                                },
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Log Stream: "
                                        },
                                        {
                                            "type": "text",
                                            "text": payload['logStream'],
                                        }
                                    ]
                                },
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "link",
                                            "url": "https://console.aws.amazon.com/cloudwatch/home?" + region + "#logsV2:log-groups/log-group/" + log_group_escaped + "/log-events/" + log_stream_escaped + "$3FfilterPattern$3D$26start$3D" + log_timestamp_start + "$26end$3D" + log_timestamp_endtime,
                                            "text": "Link to Error"
                                        }
                                    ]
                                },
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "link",
                                            "url": "https://console.aws.amazon.com/cloudwatch/home?" + region + "#logsV2:log-groups/log-group/arn$253Aaws$253Alogs$253A" + region + "$253A" +
                                                   payload[
                                                       'owner'] + "$253Alog-group$253A" + log_group_escaped + "/log-events/" + log_stream_escaped + "$3FfilterPattern$3D$26start$3D" + log_timestamp_start + "$26end$3D" + log_timestamp_endtime,
                                            "text": "Link to Centralized Logging Error"
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "divider"
                },
                {
                    "type": "rich_text",
                    "elements": [
                        {
                            "type": "rich_text_section",
                            "elements": [
                                {
                                    "type": "text",
                                    "text": "Log Error"
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "section",
                    "text": {
                        "type": "plain_text",
                        "text": logEvent['message']
                    }
                }
            ]
        }
        print(msg)
    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url, body=encoded_msg)
    print({
        "status_code": resp.status,
        "response": str(resp.data, "utf-8")
    })
