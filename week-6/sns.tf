resource "aws_sns_topic" "sns_topic" {
  name = "edu-lohika-training-aws-sns-topic"
}

output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}
