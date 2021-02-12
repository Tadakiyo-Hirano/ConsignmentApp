FROM ruby:2.6.3
# RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
# RUN apt-get update && apt-get install -y postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# yarnパッケージ管理ツールをインストール
# RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
# apt-get update && apt-get install -y yarn

RUN apt-get update -y && \
    apt-get install postgresql-client nodejs npm -y && \
    npm uninstall yarn -g && \
    npm install yarn --check-files -g -y

WORKDIR /myproject

ADD Gemfile /myproject/Gemfile
ADD Gemfile.lock /myproject/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /myproject