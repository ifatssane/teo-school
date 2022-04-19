FROM node:alpine
LABEL maintainer="jaouad.ifatssane@gmail.com"

WORKDIR /usr/app

RUN npm install redis@3.0.2 express

COPY . .

EXPOSE 80
CMD ["node", "webui.js"]
