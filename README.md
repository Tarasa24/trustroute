<center>
<img align="left" src="https://github.com/Tarasa24/trustroute/blob/main/public/img/logo_400x400.png?raw=true" height="128">
<h1>Trustroute</h1>
Ruby on Rails application for visualizing and managing web of trust of PGP public keys.
</center>
</br>

---

## Abstract
The digital communication environment requires data security and identity verification. The concept of web of trust within PGP (Pretty Good Privacy) brings the possibility of identity verification using digital signatures and trust directly between users. Existing tools that implement PGP, however, often do not include this concept. Part of this work is therefore a web application that allows users to visualize and manage the web of trust. The work further analyzes the theoretical foundations of asymmetric cryptography, the principles of the web of trust, and the problems associated with centralized identity verification solutions.

## Changelog
Available in the [CHANGELOG.md](CHANGELOG.md) file.

## Table of contents
- [Abstract](#abstract)
- [Changelog](#changelog)
- [Table of contents](#table-of-contents)
- Development
  - [How to build (using nix-shell and Docker)](#how-to-build-using-nix-shell-and-docker)
  - [How to build (native)](#how-to-build-native)
  - [How to run](#how-to-run)
- Production
  - [How to deploy](#how-to-deploy)

## Development

### How to build (using nix-shell and Docker)
Using `nix-shell` as **a development shell** simplifies the setup process because all dependencies are pre-defined. You just enter a shell, and everything you need is ready to go, ensuring consistency and avoiding conflicts with your system's global packages. For more information and installation instructions, visit the [Nix website](https://nixos.wiki/wiki/Development_environment_with_nix-shell).

While nix is a perfect abstraction for development shell, it is in my opinion not the best choice for
running required services. Therefore, I turn to Docker for running services like Neo4j, Elasticsearch, and Redis in the background via `docker-compose`.

#### Prerequisites
- [Nix package manager](https://nixos.org/download.html)
- [Docker](https://docs.docker.com/get-docker/)

#### Steps
**1. Clone the repository**
```bash
git clone https://github.com/Tarasa24/trustroute.git
cd trustroute
```

**2. Enter the nix-shell**
```bash
nix-shell
```
Now you are in the nix-shell environment, and all dependencies are installed. You can proceed with the build process.

**3. Install the dependencies**

Use package managers `bundler` for Ruby and `yarn` for JavaScript to install the required dependencies.
```bash
bundle install && yarn install
```

**4. Start the required services**

Using `docker-compose`, you can start the required services in the background. The services are defined in the `docker-compose.yml` located in the root directory.
```bash
docker-compose up -d
```

**5. Migrate and seed the database**

Set up the database schema and seed the database with initial data.
```bash
rails neo4j:migrate && rails db:seed
```

### How to build (native)
If you prefer to install the dependencies on your system, you can follow these steps. This approach is more flexible but requires more manual work. The following steps are tested on Ubuntu 20.04.
This approach is not my preferred way of setting up the development environment, but it is a valid alternative.

#### Prerequisites
- [Ruby 3.0.0](https://www.ruby-lang.org/en/downloads/)
  - [Bundler](https://bundler.io/)
  - [Overmind](https://github.com/DarthSim/overmind)
- [Node.js 20.x](https://nodejs.org/en/download/)
  - [Yarn](https://yarnpkg.com/getting-started/install)
- [Neo4j](https://neo4j.com/download/)
- [Elasticsearch](https://www.elastic.co/downloads/elasticsearch)
- [Redis](https://redis.io/download)
- [GnuPG](https://gnupg.org/download/)
  - [GPGME](https://gnupg.org/software/gpgme/index.html)

#### Steps
**1. Clone the repository**

```bash
git clone https://github.com/Tarasa24/trustroute.git
cd trustroute
```

**2. Install the dependencies**

Use package managers `bundler` for Ruby and `yarn` for JavaScript to install the required dependencies.
```bash
bundle install && yarn install
```

**3. Start the required services**

As we are not using Docker, you need to start the required services manually. You can use the following commands to start the services.
```bash
service neo4j start
service elasticsearch start
service redis-server start
```

Make sure the services are running and accessible. Neo4j at `http://localhost:7474`, Elasticsearch at `http://localhost:9200`, and Redis at `localhost:6379`.

**4. Migrate and seed the database**

Set up the database schema and seed the database with initial data.
```bash
rails neo4j:migrate && rails db:seed
```

### How to run
After you have set up the development environment, we need to set up a couple more things before we can run the application.

**1. Create OAuth Applications**

Set up OAuth applications for GitHub, Twitter, and Discord. Each application will provide a client ID and secret, which will be needed for user authentication and therefore external identity verification. You can create the applications on the respective platforms.
- [GitHub](https://github.com/settings/applications/new)
  - Homepage URL: `http://localhost:3000`
  - Authorization callback URL: `http://localhost:3000/oauth_identities/github/callback`
- [Twitter](https://developer.twitter.com/en/apps)
  - Website URL: `http://localhost:3000`
  - Callback URLs: `http://localhost:3000/oauth_identities/twitter2/callback`
- [Discord](https://discord.com/developers/applications)
  - Redirects: `http://localhost:3000/oauth_identities/discord/callback`
- TBA...

**2. Recreate the Credentials**

After cloning the repository contains a file `config/credentials.yml.enc` that contains the encrypted credentials. This file is encrypted using a master key that is not included in the repository. You need to recreate the credentials file with your own master key. You can do this by running the following command.
```bash
rm config/credentials.yml.enc
rails credentials:edit
```

**3. Append the OAuth secrets to the credentials file**

Add the OAuth secrets to the credentials file, the application expects the following keys to be present.
```yaml
oauth_providers:
  github:
    id: YOUR_GITHUB_CLIENT_ID
    secret: YOUR_GITHUB_CLIENT_SECRET
  twitter2:
    id: YOUR_TWITTER_CLIENT_ID
    secret: YOUR_TWITTER_CLIENT_SECRET
  discord:
    id: YOUR_DISCORD_CLIENT_ID
    secret: YOUR_DISCORD_CLIENT_SECRET
```

**4. Start the application**

Using `overmind`, you can start the application and the required services in the background. The services are defined in the `Procfile.dev` located in the root directory.
```bash
overmind start
```

**5. Access the application**

The application should be running on `http://localhost:3000`.

## Production
For production deployment, I recommend using Docker and Docker Compose. The following steps describe how to deploy the application using Docker Compose. While possible to deploy the application using other methods, I cannot provide support for those methods apart from setting the required environment variables `RAILS_ENV=production`.

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/)

### How to deploy
**1. Create OAuth Applications**

Set up OAuth applications for GitHub, Twitter, and Discord, as described in the development setup.

**2. Setup the `.env` File**

Copy the example environment configuration file and fill it with your credentials.
```bash
cp docker/.env.example docker/.env
```

```bash
cat docker/.env
# Application configuration
SECRET_KEY_BASE=CHANGEME # Generate random key to base encryption on (e.g. `openssl rand -hex 64`)

# Database configuration
NEO4J_URL=neo4j://neo4j:7687
NEO4J_AUTH=neo4j/password

# Search engine configuration
ELASTICSEARCH_URL=http://elasticsearch:9200

# Cache configuration
REDIS_URL=redis://redis:6379/0

# Email configuration
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=465
SMTP_DOMAIN=example.com
SMTP_USER_NAME=trustroute@example.com
SMTP_PASSWORD=password
SMTP_SSL=true
SMTP_TLS=true
SMTP_AUTHENTICATION=login

# OAuth configuration
GITHUB_ID=id
GITHUB_SECRET=secret
TWITTER2_ID=id
TWITTER2_SECRET=secret
DISCORD_ID=id
DISCORD_SECRET=secret
```

**3. Pull the Latest Image (or Build Locally)**

Ensure you have the latest Docker image, or build it locally if necessary.

```bash
docker compose -f docker/docker-compose.yaml pull
# or
docker compose -f docker/docker-compose.yaml build
```

**4. Start the Application**

Start the application using Docker Compose. Whole stack will be started in the background including the required services.

```bash
docker compose -f docker/docker-compose.yaml up -d
```

**5. Seed with Example Data (Optional)**

If desired, seed the database with example data such as the [Arch Linux developers' web of trust](https://archlinux.org/master-keys/).This step is optional.

```bash
docker compose -f docker/docker-compose.yaml exec app bundle exec rake db:seed
```

**6. Access the Application**

The application should be running on `http://localhost:3000`.
