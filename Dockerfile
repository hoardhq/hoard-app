FROM ruby:2.2.3-slim
MAINTAINER Marc Qualie <marc@marcqualie.com>

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y build-essential libpq-dev libxml2-dev nodejs \
 && gem update --system \
 && gem install --update-sources --bulk-threshold 250 --no-document \
    bcrypt \
    clockwork codecov \
    derailed \
    groupdate \
    haml-rails \
    interactor \
    nokogiri \
    pg puma \
    rails rails_12factor \
    sass-rails sidekiq \
    uglifier \
 && apt-get clean \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV RAILS_ENV production
WORKDIR /app
ADD Gemfile* /app/
RUN bundle install --without development test
ADD . /app/
RUN rake assets:precompile

EXPOSE 8090
CMD ["bundle", "exec", "puma", "-t", "8:8", "-w", "1", "-e", "production", "-p", "8090"]
