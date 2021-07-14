FROM arm64v8/python:slim

WORKDIR /opt/rpi-streaming

COPY requirements-pi.txt requirements.txt
# Total hack to get picamera to build inside the container; normally
# the library insists on building only on a RPi
ENV READTHEDOCS=True
RUN pip install -r requirements.txt

COPY *.py .
COPY templates templates

RUN pip install gevent gunicorn
EXPOSE 5000
CMD ["gunicorn", "--worker-class", "gevent", "--workers", "1", "--bind", "0.0.0.0:5000", "app:app"]
# Default to capture from Raspberry Pi
ENV CAMERA=pi
