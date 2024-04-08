FROM ruby:3.3.0-slim-bullseye

WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    sqlite3 \
    gnupg \
    pgpdump \
    git curl && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn && \
    rm -rf /var/lib/apt/lists/*

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --check-files

# Install gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN gem install bundler && \
    bundle install --jobs 4

# Copy the application code
COPY . .

# Set the environment
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=unused

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose ports
EXPOSE 3000

# Set the entrypoint command
CMD ["rails", "server", "-b", "0.0.0.0"]