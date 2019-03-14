FROM ruby:2.6.2
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /egsl-website-api
WORKDIR /egsl-website-api
COPY Gemfile /egsl-website-api/Gemfile
COPY Gemfile.lock /egsl-website-api/Gemfile.lock
RUN bundle install
RUN gem install mailcatcher
COPY . /egsl-website-api

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
