data "terraform_remote_state" "ecs_state" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_s3_bucket}"
    key = "${var.stackname}-${var.UniqueID}/thumbnailer.state"
  }
}

data "terraform_remote_state" "stack_state" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_s3_bucket}"
    key = "${var.stackname}-${var.UniqueID}/stack.state"
  }
}
