# Thumbnailer

Creating thumbnails from every archive.mp4 thats uploaded to S3.

## Flow
    Client/Server [Upload mp4] -> S3 [Event Notification] -> SQS [Enqueue] -> Thumbnailer Container on ECS [Pull, Process, Upload thumbnail] -> S3

## Docker image building and pushing to registry

```
$ ./build.sh v1
```

## Prerequisites

* ECS cluster
* SQS
* Configured S3 Event Notications

## Deployment


Depoloyment is performed with terraform

```
$ cd tf-aws-thumbnailer
$ cp config.sh.example config.sh
```

Edit config.sh

```
$ ./deploy.sh plan
$ ./deploy.sh apply
```
