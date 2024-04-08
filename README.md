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

3. Migrate the database
```bash
rails neo4j:migrate
```

4. Seed the database with some data
```bash
rails db:seed
```

## How to run

1. Create following oAuth applications
    1. [GitHub](https://github.com/settings/applications/new) - set callback URL to `/oauth_identities/github/callback`
    2. [Twitter](https://developer.twitter.com/en/apps) - set callback URL to `/oauth_identities/twitter2/callback`
    3. [Discord](https://discord.com/developers/applications) - set callback URL to `/oauth_identities/discord/callback`

2. Recreate the credentials
```bash
rm config/credentials.yaml.enc
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

6. App is now running on `localhost:3000`

## How to deploy

1. Create following oAuth applications
    1. [GitHub](https://github.com/settings/applications/new) - set callback URL to `/oauth_identities/github/callback`
    2. [Twitter](https://developer.twitter.com/en/apps) - set callback URL to `/oauth_identities/twitter2/callback`
    3. [Discord](https://discord.com/developers/applications) - set callback URL to `/oauth_identities/discord/callback`

2. Setup `.env` file
```bash
cp docker/.env.example docker/.env
```

3. Fill the `.env` file with the credentials
```bash
vim docker/.env
```

4. Pull the latest image (or build it locally)
```bash
docker compose -f docker/docker-compose.yaml pull

# or
docker compose -f docker/docker-compose.yaml build
```

5. Run the application
```bash
docker compose -f docker/docker-compose.yaml up
```

6. (First time only) Migrate the database and seed production data
```bash
docker compose -f docker/docker-compose.yaml exec app bundle exec rake neo4j:migrate
docker compose -f docker/docker-compose.yaml exec app bundle exec rake db:seed
```

7. App is now running on `localhost:3000`

## How to use

### Sign up flow

1. Have a PGP keypair
2. Import the public key into the application `/keys/new`
3. Sign in using signature challenge `/key_sessions/new`

### Managing identities flow
1. Navigate to identities management page `/keys/:uuid/edit`
2. Add oAuth idenity using one of the providers
3. Add and verify email address
4. Add and verify DNS record

### Vouching flow
1. Navigate to the key you want to vouch for `/keys/:uuid`
2. Click on the `Vouch` button
3. Confirm vouching checklist
4. Create key signature using and upload it to the application

### Revoking key flow
1. Navigate to your key `/keys/:uuid`
2. Click on the `Revoke` button
3. Create and upload revocation certificate

### Searchign flow
1. Navigate to the root page `/`
2. Use the search bar to find the key you are interested in (e.g. by email address, DNS record, etc.)
3. Click on the key to see the details

### Trust checking flow
1. Navigate to the key you want to trust `/keys/:uuid`
2. Using the visuaisation check the path of trust from your key to the key you want to trust
3. Consider key's identities and vouches and optionally contact intermediaries

## Technologies

- Ruby on Rails
- gpgme
- neo4j
- ElasticSearch
- Vite
- Scss
- Docker
- NixOS

...