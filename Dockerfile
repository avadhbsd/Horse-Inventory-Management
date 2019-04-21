FROM ruby:2.5.1

RUN apt-get update -qq && \
     apt-get install -y nodejs postgresql-client && \
     apt-get -q clean && \
     rm -rf /var/lib/apt/lists

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

RUN gem install bundler

ENV BUNDLER_VERSION 2.0.1

RUN bundle install

COPY . .
