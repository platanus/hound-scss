FROM ruby:2.3.1

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY package.json /usr/src/app/
RUN npm install

COPY . /usr/src/app

CMD bundle exec rake jobs:work
