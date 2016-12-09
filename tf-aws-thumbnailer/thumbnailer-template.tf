data "template_file" "thumbnailer_task" {
  template = "${file("${path.module}/thumbnailer-task-defition.json")}"

  vars = {
    QueueName = "${var.QueueName}"
    VisibilityTimeout = "${var.VisibilityTimeout}"
    WaitTimeSeconds = "${var.WaitTimeSeconds}"
    DOCKER_IMAGE = "${var.DOCKER_IMAGE}"
    AWS_DEFAULT_REGION = "${var.AWS_DEFAULT_REGION}"
  }
}