# credentials\_app

Lets users transform generate their password hashes.

It's not integrated into anything yet. This is meant to be a temporary solution
until we have time to solve authentication in a way that makes sense for all teams.

## Dependencies

System

- Ruby 2+
- `whois` package for mkpasswd (Linux passwords)
- `apache2-utils` for htpasswd (HTTP Auth)
- `mysql-server` for MySQL password hashes

Ruby

```bash
bundle install
```

## Run the app

```bash
bundle exec rackup config.ru
```
