FROM ruby:2.6-alpine
MAINTAINER Kevin Blues <kbluescode@gmail.com>

ARG DEPS="\
bash \
dumb-init \
git \
"
RUN apk update && apk add --no-cache $DEPS
RUN gem install bundler -v '~> 1'
WORKDIR /root
COPY . /root
RUN bundle
CMD dumb-init tail -f /dev/null