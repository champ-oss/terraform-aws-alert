import json
import re
import os
import boto3
import urllib3
import gzip
import base64

# Lambda global variables
slack_url = os.environ["SLACK_URL"]
region    = os.environ["REGION"]

http = urllib3.PoolManager()
def lambda_handler(event, context):
    url = slack_url

    encoded_zipped_data = event['awslogs']['data']
    zipped_data = base64.b64decode(encoded_zipped_data)
    uncompressed_payload  = gzip.decompress(zipped_data)
    payload = json.loads(uncompressed_payload)

    for logEvent in payload['logEvents']:
       log_group_name = payload['logGroup']
       log_stream_name = payload['logStream']
       log_group_escaped = log_group_name.replace('/', '$252F')
       log_stream_escaped = log_stream_name.replace('/', '$252F')
       log_timestamp_start = str(logEvent['timestamp'])
       log_timestamp_endtime = str(logEvent['timestamp'] + 60000)
       msg = {
       'text': payload['logGroup'] + ":  ERROR reported",
       'attachments': [{
         'fields': [{
            'title': 'Time',
            'value': logEvent['timestamp'],
            'short': True,
         }, {
            'title': 'Account',
            'value': payload['owner'],
            'short': True,
         }, {
            'title': 'Log Group',
            'value': payload['logGroup'],
            'short': True,
         }, {
            'title': 'Log Stream',
            'value': payload['logStream'],
            'short': True,
         }, {
            'title': 'Log Error',
            'value': logEvent['message'],
            'short': False,
         }, {
            'value': "<https://console.aws.amazon.com/cloudwatch/home?" + region + "#logsV2:log-groups/log-group/" + log_group_escaped + "/log-events/" + log_stream_escaped + "$3FfilterPattern$3D$26start$3D" + log_timestamp_start + "$26end$3D" + log_timestamp_endtime + "|Link to Error>",
            'short': False,
         }, {
            'value': "<https://console.aws.amazon.com/cloudwatch/home?" + region + "#logsV2:log-groups/log-group/arn$253Aaws$253Alogs$253A" + region + "$253A" + payload['owner'] + "$253Alog-group$253A" + log_group_escaped + "/log-events/" + log_stream_escaped + "$3FfilterPattern$3D$26start$3D" + log_timestamp_start + "$26end$3D" + log_timestamp_endtime + "|Link to Centralized Log Account Error>",
            'short': False
         }],
       }],
       }
       encoded_msg = json.dumps(msg).encode('utf-8')
       resp = http.request('POST',url, body=encoded_msg)

       print({
           "status_code": resp.status,
           "response": str(resp.data, "utf-8")
       })