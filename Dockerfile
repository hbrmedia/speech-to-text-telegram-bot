FROM ruby:3.1.2-bullseye

RUN apt-get update -qq && apt-get install -y \
    tzdata \
    build-essential \
    curl \
    ca-certificates \
    gnupg \
    cron \
    vim

RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

ENV TZ="Europe/Moscow"

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=5 --retry=3

COPY . ./

ENTRYPOINT ["./docker-entrypoint.sh"]
