FROM python
LABEL maintainer="jaouad.ifatssane@gmail.com"

ADD worker.py /dockercoins/worker/

WORKDIR /dockercoins/worker/

RUN pip install redis
RUN pip install requests

EXPOSE 80

CMD ["python", "worker.py"]
