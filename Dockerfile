FROM ruby:2.6

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN gem install bundler
RUN bundle install

COPY . .

CMD ["ruby", "./app.rb"]
