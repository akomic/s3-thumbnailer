import boto3
import json
import os
import subprocess
import sys
import time
import logging

logging.basicConfig(
    format='[%(asctime)s] - %(levelname)s: %(name)s: %(message)s',
    datefmt='%a %b %d %H:%M:%S %Y',
    level=logging.INFO
)
logging.getLogger("boto3").setLevel(logging.WARNING)
logging.getLogger("botocore").setLevel(logging.WARNING)

# Get the service resource
sqs = boto3.resource('sqs')
s3 = boto3.resource('s3')

# Get the queue
queue = sqs.get_queue_by_name(QueueName=os.getenv("QueueName", 'RecordingIncoming'))

logging.info("Start QueueName: %s" % os.getenv("QueueName", 'RecordingIncoming'))
while True:
    data = ""
    try:
        for message in queue.receive_messages(VisibilityTimeout=int(os.getenv("VisibilityTimeout", 5)), WaitTimeSeconds=int(os.getenv("WaitTimeSeconds", 20))):
            data = json.loads(message.body)

            s3bucket = data['Records'][0]['s3']['bucket']['name']
            recording_key = data['Records'][0]['s3']['object']['key']
            recording_dir = os.path.dirname(data['Records'][0]['s3']['object']['key'])
            thumbnail_key = os.path.join(recording_dir, 'thumbnail.png')

            s3.meta.client.download_file(s3bucket, recording_key, '/tmp/archive.mp4')

            subprocess.check_output(["ffmpegthumbnailer", "-i", "/tmp/archive.mp4", "-o", "/tmp/thumbnail.png", "-s", "320"], stderr=subprocess.STDOUT)

            if os.path.exists('/tmp/thumbnail.png'):
                s3.meta.client.upload_file(
                        '/tmp/thumbnail.png',
                        s3bucket,
                        thumbnail_key
                    )

            logging.info("Finished %s/%s" % (s3bucket, recording_key))
            message.delete()
    except Exception as e:
        logging.error("ERROR: %s" % str(data))
        logging.error("ERROR: %s" %str(e))

    time.sleep(10)
