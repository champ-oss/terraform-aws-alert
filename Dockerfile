FROM public.ecr.aws/lambda/python:3.12

COPY cloudwatch_slack.py "${LAMBDA_TASK_ROOT}"
COPY requirements.txt "${LAMBDA_TASK_ROOT}"
RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

CMD [ "cloudwatch_slack.lambda_handler" ]