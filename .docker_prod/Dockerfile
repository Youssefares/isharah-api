FROM ruby:2.6.2

# Install dependencies not in Gemfile
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client ffmpeg ffmpegthumbnailer

ENV RAILS_ROOT /var/www/isharah
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test 

# Adding project files
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]