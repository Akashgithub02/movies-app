FROM ruby:3.2.2-slim


WORKDIR /app

USER root


RUN rm -rf /var/lob/apt/lists/* \
    && apt-get clean \
    && dpkg --configure -a \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    yarn

COPY Gemfile Gemfile.lock /app/

RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]