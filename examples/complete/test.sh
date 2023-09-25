set -e

aws logs put-log-events \
--log-group-name $CLOUDWATCH_LOG_GROUP \
--log-stream-name $CLOUDWATCH_LOG_STREAM \
--log-events timestamp=`date +%s`,message="2022-03-27 03:33:17.998 ERROR 7 --- main test"

sleep 30

aws logs tail --since 30m $ALERT_CLOUDWATCH_LOG_GROUP
