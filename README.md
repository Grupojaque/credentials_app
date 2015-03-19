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
bundle exec rackup config.ru # port 9292
# or
bundle exec rackup config.ru -p 3000 # port 3000
```

## Development

This is a simple Sinatra app (a small Ruby web framework). Learn more about it
[here](http://www.sinatrarb.com/intro.html).
