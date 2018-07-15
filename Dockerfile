FROM ruby:2.4-jessie

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p /var/www/challange-api

ADD Gemfile /var/www/challange-api/Gemfile
ADD Gemfile.lock /var/www/challange-api/Gemfile.lock

WORKDIR /var/www/challange-api

RUN bundle install
