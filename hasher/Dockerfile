FROM ruby:alpine
LABEL maintainer="jaouad.ifatssane@gmail.com"

RUN apk add --update build-base curl && \
    gem install sinatra && \
    gem install thin

ADD hasher.rb /dockercoins/hasher/
WORKDIR /dockercoins/hasher/

EXPOSE 80
CMD ["ruby", "hasher.rb"]
