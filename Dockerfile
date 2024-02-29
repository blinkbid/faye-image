ARG RUBY_VERSION=2.7.8
ARG DISTRO_NAME=bullseye

FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME

ARG DISTRO_NAME

# Commom dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends build-essential \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV WORKDIR /opt/app

RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

COPY config.ru .

RUN gem install faye \
  && gem install rack \
  && gem install thin

EXPOSE 9292

CMD ["rackup", "config.ru", "-E", "production", "-s", "thin", "-o", "0.0.0.0"]
