FROM ruby:2.5.0-alpine

# Update the packages.
RUN apk add --update --no-cache alpine-sdk

# Install build dependencies (c++, make, etc).
RUN apk add --no-cache build-base

# Create a directory for the library.
RUN mkdir -p /usr/src/app/lib/json_partials
WORKDIR /usr/src/app

# Copy the files required to install the gems.
COPY Gemfile* /usr/src/app/
COPY json_partials.gemspec /usr/src/app/
COPY lib/json_partials/version.rb /usr/src/app/lib/json_partials/

# Install the same version of Bundler that was used to create the Gemfile.lock.
RUN gem install bundler --version=$(tail -n1 Gemfile.lock | awk '{$1=$1};1')

# Install the gems listed in the Gemfile.
RUN bundle install --no-deployment --without="" --jobs=4
