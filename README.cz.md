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

## Změny
Dostupné v souboru [CHANGELOG.md](CHANGELOG.md).

## Obsah
- [Abstrakt](#abstrakt)
- [Změny](#změny)
- [Obsah](#obsah)
- Vývojové prostředí
  - [Jak sestavit (pomocí nix-shell a Dockeru)](#jak-sestavit-pomocí-nix-shell-a-dockeru)
  - [Jak sestavit (nativně)](#jak-sestavit-nativně)
  - [Jak spustit](#jak-spustit)
- Produkční prostředí
  - [Jak nasadit](#jak-nasadit)

## Vývojové prostředí

### Jak sestavit (pomocí nix-shell a Dockeru)
Použití `nix-shell` jako **vývojového shellu** zjednodušuje proces nastavení, protože všechny závislosti jsou předdefinovány. Stačí vstoupit do shellu a vše potřebné je připraveno k použití, což zajišťuje konzistenci a vyhýbá se konfliktům s globálními balíčky systému. Pro více informací a instalační pokyny navštivte [web Nix](https://nixos.wiki/wiki/Development_environment_with_nix-shell).

Ačkoli je nix ideální abstrakcí pro vývojový shell, podle mého názoru není nejlepší volbou pro spouštění potřebných služeb. Proto používám Docker pro spuštění služeb jako Neo4j, Elasticsearch a Redis na pozadí pomocí `docker-compose`.

#### Předpoklady
- [Správce balíčků Nix](https://nixos.org/download.html)
- [Docker](https://docs.docker.com/get-docker/)

#### Kroky
**1. Klonujte repozitář**
```bash
git clone https://github.com/Tarasa24/trustroute.git
cd trustroute
```

**2. Vstupte do nix-shell**
```bash
nix-shell
```
Nyní jste v prostředí nix-shell a všechny závislosti jsou nainstalovány. Můžete pokračovat v procesu sestavení.

**3. Nainstalujte závislosti**

Použijte správce balíčků `bundler` pro Ruby a `yarn` pro JavaScript k instalaci požadovaných závislostí.

```bash
bundle install && yarn install
```

**4. Spusťte požadované služby**

Pomocí `docker-compose` můžete spustit požadované služby na pozadí. Služby jsou definovány v souboru `docker-compose.yml` nacházejícím se v kořenovém adresáři.

```bash
docker-compose up -d
```

**5. Migrujte a naplňte databázi**

Nastavte schéma databáze a naplňte databázi počátečními daty.
```bash
rails neo4j:migrate && rails db:seed
```

### Jak sestavit (nativně)

Pokud preferujete instalaci závislostí ve vašem systému, můžete postupovat podle těchto kroků. Tento přístup je flexibilnější, ale vyžaduje více manuální práce. Následující kroky byly testovány na Ubuntu 20.04. Tento přístup není můj preferovaný způsob nastavení vývojového prostředí, ale je to platná alternativa.

#### Předpoklady
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

#### Kroky
**1. Klonujte repozitář**

```bash
git clone https://github.com/Tarasa24/trustroute.git
cd trustroute
```

**2. Nainstalujte závislosti**

Použijte správce balíčků `bundler` pro Ruby a `yarn` pro JavaScript k instalaci požadovaných závislostí.

```bash
bundle install && yarn install
```

**3. Spusťte požadované služby**

Protože nepoužíváme Docker, musíte služby spustit ručně. Můžete použít následující příkazy ke spuštění služeb.

```bash
service neo4j start
service elasticsearch start
service redis-server start
```

Ujistěte se, že služby běží a jsou přístupné. Neo4j na http://localhost:7474, Elasticsearch na http://localhost:9200 a Redis na localhost:6379.

**4. Migrujte a naplňte databázi**

Nastavte schéma databáze a naplňte databázi počátečními daty.

```bash
rails neo4j:migrate && rails db:seed
```

### Jak spustit

Po nastavení vývojového prostředí je třeba nastavit ještě několik dalších věcí, než bude možné aplikaci spustit.

**1. Vytvořte OAuth aplikace**

Nastavte OAuth aplikace pro GitHub, Twitter a Discord. Každá aplikace poskytne klientské ID a tajný klíč, které budou potřeba pro autentizaci uživatele a tím i pro externí ověřování identity. Aplikace můžete vytvořit na příslušných platformách.

- [GitHub](https://github.com/settings/applications/new)
  - Homepage URL: `http://localhost:3000`
  - Authorization callback URL: `http://localhost:3000/oauth_identities/github/callback`
- [Twitter](https://developer.twitter.com/en/apps)
  - Website URL: `http://localhost:3000`
  - Callback URLs: `http://localhost:3000/oauth_identities/twitter2/callback`
- [Discord](https://discord.com/developers/applications)
  - Redirects: `http://localhost:3000/oauth_identities/discord/callback`
- TBA...

**2. Vytvořte znovu tajná data**

Po klonování repozitáře obsahuje soubor `config/credentials.yml`.enc, který obsahuje šifrované přihlašovací údaje. Tento soubor je šifrován pomocí hlavního klíče, který není součástí repozitáře. Je třeba znovu vytvořit soubor přihlašovacích údajů s vlastním hlavním klíčem. To můžete udělat spuštěním následujícího příkazu.

```bash
rm config/credentials.yml.enc
rails credentials:edit
```

**3. Přidejte tajné klíče OAuth do souboru s tajnými údaji**

Přidejte OAuth tajné klíče do souboru přihlašovacích údajů, aplikace očekává, že budou přítomny následující klíče.

```yaml
oauth_providers:
  github:
    id: VAŠE_GITHUB_KLIENTSKÉ_ID
    secret: VÁŠ_GITHUB_KLIENTSKÝ_TAJNÝ_KLÍČ
  twitter2:
    id: VAŠE_TWITTER_KLIENTSKÉ_ID
    secret: VÁŠ_TWITTER_KLIENTSKÝ_TAJNÝ_KLÍČ
  discord:
    id: VAŠE_DISCORD_KLIENTSKÉ_ID
    secret: VÁŠ_DISCORD_KLIENTSKÝ_TAJNÝ_KLÍČ
```

**4. Spusťte aplikaci**

Aplikace by měla běžet na `http://localhost:3000`.

## Produkční prostředí
Pro nasazení do produkce doporučuji použít Docker a Docker Compose. Následující kroky popisují, jak nasadit aplikaci pomocí Docker Compose. I když je možné aplikaci nasadit jinými způsoby, nemohu poskytovat podporu pro tyto metody kromě nastavení požadované proměné prostředí `RAILS_ENV=production`.

### Předpoklady
- [Docker](https://docs.docker.com/get-docker/)

### Jak nasadit

**1. Vytvořte OAuth aplikace**

Nastavte OAuth aplikace pro GitHub, Twitter a Discord, jak je popsáno v nastavení vývojářského prostředí.

**2. Nastavte soubor `.env`**

Zkopírujte příklad souboru s konfigurací prostředí a vyplňte ho svými údaji.

```bash
cp docker/.env.example docker/.env
```

```bash
cat docker/.env
# Konfigurace aplikace
SECRET_KEY_BASE=ZMĚŇTEME # Generujte náhodný klíč, který bude použit jáko základ pro další šifrování (např. `openssl rand -hex 64`)

# Konfigurace databáze
NEO4J_URL=neo4j://neo4j:7687
NEO4J_AUTH=neo4j/password

# Konfigurace vyhledávacího enginu
ELASTICSEARCH_URL=http://elasticsearch:9200

# Konfigurace cache
REDIS_URL=redis://redis:6379/0

# Konfigurace e-mailu
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=465
SMTP_DOMAIN=example.com
SMTP_USER_NAME=trustroute@example.com
SMTP_PASSWORD=password
SMTP_SSL=true
SMTP_TLS=true
SMTP_AUTHENTICATION=login

# Konfigurace OAuth
GITHUB_ID=id
GITHUB_SECRET=secret
TWITTER2_ID=id
TWITTER2_SECRET=secret
DISCORD_ID=id
DISCORD_SECRET=secret
```

**3. Stáhněte nejnovější obraz (nebo sestavte lokálně)**

Ujistěte se, že máte nejnovější obraz nebo jej sestavte lokálně, pokud je to nutné.

```bash
docker compose -f docker/docker-compose.yaml pull
# nebo
docker compose -f docker/docker-compose.yaml build
```

**4. Spusťte aplikaci**

Spusťte aplikaci pomocí Docker Compose. Celý stack bude spuštěn na pozadí včetně požadovaných služeb.

```bash
docker compose -f docker/docker-compose.yaml up -d
```

**5. Naplňte aplikaci příkladovými daty (volitelné)**

Pokud chcete, můžete naplnit databázi příkladovými daty, jako je [síť důvěry vývojářů Arch Linuxu](https://archlinux.org/master-keys/). Tento krok je volitelný.

```bash
docker compose -f docker/docker-compose.yaml exec app bundle exec rake db:seed
```

**6. Přístup k aplikaci**

Aplikace by měla běžet na `http://localhost:3000`.
