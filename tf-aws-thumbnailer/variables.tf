variable "stackname" {}
variable "UniqueID" {}
variable "cluster_arn" {}
variable "remote_state_s3_bucket" {}
variable "DOCKER_VERSION" {}
variable "desired_count" {}
variable "deployment_maximum_percent" {}
variable "deployment_minimum_healthy_percent" {}
variable "QueueName" { default = "LiveRecordingIncoming" }
variable "VisibilityTimeout" { default = "300" }
variable "WaitTimeSeconds" { default = "20" }
variable "AWS_DEFAULT_REGION" { default = "us-east-1" }
