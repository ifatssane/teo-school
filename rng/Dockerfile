FROM python:alpine
LABEL maintainer="jaouad.ifatssane@gmail.com"

RUN pip install flask

ADD rng.py /dockercoins/rng/
WORKDIR /dockercoins/rng/

EXPOSE 80
CMD ["python", "rng.py"]
