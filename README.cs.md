<center>
<img align="left" src="https://github.com/Tarasa24/trustroute/blob/main/public/img/logo_400x400.png?raw=true" height="128">
<h1>Trustroute</h1>
Ruby on Rails aplikace pro vizualizaci a správu sítě důvěry PGP veřejných klíčů.
</center>
</br>

---

## Abstrakt

Svět digitálního komunikačního prostředí vyžaduje zabezpečení dat a ověření identity. Koncept síťové důvěry v rámci PGP (Pretty Good Privacy)
přináší možnost ověřování identity pomocí digitálních podpisů a důvěry přímo mezi uživateli. Existující nástroje, které implementují PGP, však tento koncept často nezahrnují.
Součásti této práce je tedy webové aplikace, která umožní uživatelům vizualizovat síť důvěry a spravovat ji.
Práce dále analyzuje teoretické základy asymetrické kryptografie, principy sítě důvěry a problémy spojené s centralizovanými řešeními ověřování identity.


## Obsah

- [Abstrakt](#abstrakt)
- [Obsah](#obsah)
- Vývojové prostředí
  - [Jak sestavit](#jak-sestavit)
  - [How spustit](#jak-spustit)
- Produkční prostředí
  - [Jak nasadit](#jak-nasadit)

## Jak sestavit

1. Vstup do [vývojářského shellu](https://nixos.org/)
```bash
nix-shell
```

2. Instalace závislosti
```bash
bundle && yarn
```

3. Migrace databáze
```bash
rails neo4j:migrate
```

4. Seed databáze s generovanými daty
```bash
rails db:seed
```

## Jak spustit

1. Je potřeba vytvořit následující oAuth aplikace:
    1. [GitHub](https://github.com/settings/applications/new) - callback URL `/oauth_identities/github/callback`
    2. [Twitter](https://developer.twitter.com/en/apps) - callback URL `/oauth_identities/twitter2/callback`
    3. [Discord](https://discord.com/developers/applications) - callback URL `/oauth_identities/discord/callback`

2. Vytvoření vlastních přístupových údajů
```bash
rm config/credentials.yaml.enc
rails credentials:edit
```

3. Přidání klient ID a secretů do souboru s přístupovými údaji
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

4. Spueštění externích služeb
```bash
docker compose up
```

5. Spuštění aplikace
```bash
overmind start
```

6. Aplikace nyní běží na `localhost:3000`

## Jak nasadit

1. Opět je třeba vytvořit oAuth aplikace:
    1. [GitHub](https://github.com/settings/applications/new) - callback URL `/oauth_identities/github/callback`
    2. [Twitter](https://developer.twitter.com/en/apps) - callback URL `/oauth_identities/twitter2/callback`
    3. [Discord](https://discord.com/developers/applications) - callback URL `/oauth_identities/discord/callback`

2. Definice `.env` souboru
```bash
cp docker/.env.example docker/.env
```

3. Vyplnění `.env` souboru vlastními údaji (podle .env.example)
```bash
vim docker/.env
```

4. Stažení předpřipraveného image (nebo sestavení vlastního)
```bash
docker compose -f docker/docker-compose.yaml pull

# nebo
docker compose -f docker/docker-compose.yaml build
```

5. Spuštění aplikace
```bash
docker compose -f docker/docker-compose.yaml up
```

6. (V případě zájmu) Seedování vzorovými daty - [síť důvěry vývojářů Arch Linux](https://archlinux.org/master-keys/)
```bash
docker compose -f docker/docker-compose.yaml exec app bundle exec rake db:seed
```

7. Aplikace nyní běží na `localhost:3000`
