FROM ruby:alpine
MAINTAINER damasceno.lnx@gmail.com

RUN apk --update add build-base imagemagick tzdata nginx

COPY Gemfile main.rb /app/
COPY config.yaml /app/

WORKDIR /app

RUN bundle install

ENV AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXX
ENV AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXX
ENV AWS_REGION=XXXXXXXXXXXXX

CMD ["ruby", "main.rb", "-o", "0.0.0.0"]
