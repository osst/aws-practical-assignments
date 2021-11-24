resource "aws_sqs_queue" "sqs_queue" {
  name                      = "edu-lohika-training-aws-sqs-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 30
}

output "sqs_queue_url" {
  value = aws_sqs_queue.sqs_queue.url
}
