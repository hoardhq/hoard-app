# FROM alpine:3.2

# RUN apk update \
#  && apk add build-base gcc postgresql-dev ruby ruby-bundler ruby-dev
# RUN apk add ruby-nokogiri
# RUN apk add zlib-dev
# RUN apk add ruby-rails4.2
# RUN gem install bcrypt
# RUN gem install pg
# RUN gem install puma
# RUN gem install bootstrap-sass font-awesome-rails haml-rails jquery-rails sass-rails
# RUN gem install nokogiri -- --use-system-libraries
# RUN apk del postgresql

# WORKDIR /app
# ADD Gemfile* /app/
# RUN bundle install --without development,test --deployment
# ADD . /app

# EXPOSE 8090
# CMD ["bundle", "exec", "puma", "-t", "8:8", "-w", "1", "-e", "production", "-p", "8090"]

FROM ruby:2.2.2-slim

ENV RAILS_ENV production
RUN apt-get update \
 && apt-get install -y build-essential nodejs libpq-dev libxml2-dev
RUN gem install bcrypt haml-rails nokogiri pg puma rails sass-rails

WORKDIR /app
ADD Gemfile* /app/
RUN bundle install --without development,test --deployment
ADD . /app/

EXPOSE 8090
CMD ["bundle", "exec", "puma", "-t", "8:8", "-w", "1", "-e", "production", "-p", "8090"]
