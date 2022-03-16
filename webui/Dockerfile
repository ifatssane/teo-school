FROM node:alpine
LABEL maintainer="jaouad.ifatssane@gmail.com"

WORKDIR /usr/app

ADD . .

RUN npm install express 
RUN npm install redis

EXPOSE 80
CMD ["node", "webui.js"]
