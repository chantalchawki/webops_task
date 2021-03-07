FROM ruby:3.0.0
WORKDIR /home/app
COPY . .
RUN gem install rails bundler:1.17.2
RUN bundle install
EXPOSE 3000
ENTRYPOINT sleep 60 && bin/rails db:migrate RAILS_ENV=development && sidekiq -c 1 & rails server -b 0.0.0.0