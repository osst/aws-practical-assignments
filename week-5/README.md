## SQS

Send message
```
aws sqs send-message --queue-url https://sqs.us-west-2.amazonaws.com/369405207418/sqs_queue --message-body "Hey" --region us-west-2
```

Receive messages
```
aws sqs receive-message --queue-url https://sqs.us-west-2.amazonaws.com/369405207418/sqs_queue --region us-west-2
```

Delete message
```
aws sqs delete-message --queue-url https://sqs.us-west-2.amazonaws.com/369405207418/sqs_queue --receipt-handle AQ...2tw== --region us-west-2
```

## SNS

Publish message
```
aws sns publish --topic-arn "arn:aws:sns:us-west-2:369405207418:sns_topic" --message "Hey" --region us-west-2
```

