FROM ruby:2.2.2-slim
MAINTAINER Marc Qualie <marc@marcqualie.com>

RUN apt-get update \
 && apt-get install -y build-essential libcurl4-openssl-dev libpq-dev libxml2-dev nodejs
RUN gem update --system \
 && gem update \
 && gem install bcrypt curb groupdate haml-rails nokogiri pg puma rails sass-rails sidekiq

ENV RAILS_ENV production
WORKDIR /app
ADD Gemfile* /app/
RUN bundle install --without development test
ADD . /app/
RUN rake assets:precompile

EXPOSE 8090
CMD ["bundle", "exec", "puma", "-t", "8:8", "-w", "1", "-e", "production", "-p", "8090"]
