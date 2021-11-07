resource "aws_sns_topic" "sns_topic" {
  name = "sns_topic"
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "osst.os@gmail.com"
}

output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}
