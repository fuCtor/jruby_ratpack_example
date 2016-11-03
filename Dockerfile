FROM jruby:9.1.2

RUN apt-get update && apt-get install -y git-core --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem install bundler --no-ri --no-rdoc

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle config --global --jobs 8
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without development test --deployment

ADD Jarfile /app/Jarfile
ADD Jarfile.lock /app/Jarfile.lock
RUN jbundle install --without development test --deployment

RUN mkdir /app/log

ADD . /app

