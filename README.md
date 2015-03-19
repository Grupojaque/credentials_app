# credentials\_app

Lets users generate their password hashes.

It's not integrated into anything yet. This is meant to be a temporary solution
until we have time to solve authentication in a way that makes sense for everyone.

## Dependencies

System (Ubuntu is assumed)

- Ruby 2+
- `whois` package for mkpasswd (Linux passwords)
- `apache2-utils` for htpasswd (HTTP Auth)
- `mysql-server` for MySQL password hashes

Ruby

```bash
bundle install
```

## Run the app

At its simplest:

```bash
bundle exec ruby credentials.rb
```

Specify the my.cnf file to use:

```bash
MYCNF=/etc/credentials_app/my.cnf bundle exec ruby credentials.rb
```

This is a simple Sinatra app (a small Ruby web framework).
Learn more about Sinatra [here](http://www.sinatrarb.com/intro.html).
Additional command line flags are supported by Sinatra (port, bind address, etc.)
