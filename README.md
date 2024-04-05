<center>
<img align="left" src="https://github.com/Tarasa24/trustroute/blob/main/public/img/logo_400x400.png?raw=true" height="128">
<h1>Trustroute</h1>
Ruby on Rails application for visualizing and managing web of trust of PGP public keys.
</center>
</br>

---

## Abstract

...

## Table of contents

- [Abstract](#abstract)
- [Table of contents](#table-of-contents)
- Development
  - [How to build](#how-to-build)
  - [How to run](#how-to-run)
- Production
  - [How to deploy](#how-to-deploy)
- [How to use](#how-to-use)
- [Technologies](#technologies)

## How to build

1. Enter development [environment shell](https://nixos.org/)
```bash
nix-shell
```

2. Install dependencies
```bash
bundle && yarn
```

3. Create database
```bash
rails db:create && rails db:migrate
```

4. (Optional) Seed the database with some data (e.g. for development purposes)
```bash
rails db:seed
```

## How to run

1. Create following oAuth applications
    1. [GitHub](https://github.com/settings/applications/new)
    2. [Twitter](https://developer.twitter.com/en/apps)
    3. [Discord](https://discord.com/developers/applications)

2. Recreate the credentials
```bash
rm config/credentials.yml.enc
rails credentials:edit
```

3. Append client IDs and secrets to the credentials file
```yaml
oauth_providers:
  github:
    id: ...
    secret: ...
  twitter2:
    id: ...
    secret: ...
  discord:
    id: ...
    secret: ...
```

4. Run the external services
```bash
docker compose up
```

5. Run the application
```bash
overmind start
```

## How to deploy

1. Create following oAuth applications
    1. [GitHub](https://github.com/settings/applications/new)
    2. [Twitter](https://developer.twitter.com/en/apps)
    3. [Discord](https://discord.com/developers/applications)

2. Setup `.env` file
```bash
cp docker/.env.example docker/.env
```

3. Fill the `.env` file with the credentials
```bash
vim docker/.env
```

4. (Optional) Pull the latest image
```bash
docker compose -f docker/docker-compose.yml pull
```

5. Run the application
```bash
docker compose -f docker/docker-compose.yml up
```

## How to use

...

## Technologies

- Ruby on Rails

...