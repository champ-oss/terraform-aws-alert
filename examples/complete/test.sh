set -e

aws logs put-log-events \
--log-group-name $CLOUDWATCH_LOG_GROUP \
--log-stream-name $CLOUDWATCH_LOG_STREAM \
--log-events timestamp=`date +%s%3N`,message="2022-03-27 03:33:17.998 ERROR 7 --- main test"

sleep 30

ALERT_LOGS=$(aws logs tail --since 30m $ALERT_CLOUDWATCH_LOG_GROUP)
echo $ALERT_LOGS
echo $ALERT_LOGS | grep -vi error
echo $ALERT_LOGS | grep -i "{'status_code': 200, 'response': 'ok'}"
