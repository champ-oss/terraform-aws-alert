set -e

  if [ "$ENABLED" = "true" ]; then
    echo "Module is enabled"
    aws logs put-log-events \
    --log-group-name $CLOUDWATCH_LOG_GROUP \
    --log-stream-name $CLOUDWATCH_LOG_STREAM \
    --log-events timestamp=`date +%s%3N`,message="2022-03-27 03:33:17.998 ERROR 7 --- main test"
    sleep 300

    aws logs tail $CLOUDWATCH_LOG_GROUP | grep -vi error
    aws logs tail $CLOUDWATCH_LOG_GROUP | grep -i "{'status_code': 200, 'response': 'ok'}"
  else
    echo "Module is disabled, no resources created"
  fi
