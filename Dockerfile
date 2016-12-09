FROM python:2.7.12

COPY thumbnailer.py requirements.txt /app/

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpegthumbnailer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip install -r /app/requirements.txt

CMD [ "python", "/app/thumbnailer.py"]
