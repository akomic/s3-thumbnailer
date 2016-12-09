resource "aws_ecs_service" "thumbnailer" {
  name            = "tf-${var.stackname}-thumbnail-service"
  cluster         = "${var.cluster_arn}"
  task_definition = "${aws_ecs_task_definition.thumbnailer.arn}"
  desired_count   = "${var.desired_count}"
  deployment_maximum_percent = "${var.deployment_maximum_percent}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
}

resource "aws_ecs_task_definition" "thumbnailer" {
  family = "thumbnailer"
  container_definitions = "${data.template_file.thumbnailer_task.rendered}"
}
