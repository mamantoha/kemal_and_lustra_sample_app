# Kemal and Clear Sample Application

It's an example of traditional blog-like application with `post` objects, which have a `title` and `content`.
A `post` is associated to an `author` via a foreign key.
A `post` itself can have multiple tags.
A `post` has self-referential association to define leaders/followers.

![database structure](https://raw.githubusercontent.com/mamantoha/kemal_and_clear_sample_app/master/db.png)

## Development

```bash
psql -c 'DROP DATABASE IF EXISTS kemal_and_clear_sample_app;' -U postgres
psql -c 'CREATE DATABASE kemal_and_clear_sample_app;' -U postgres
crystal ./src/db_cli.cr migrate
crystal ./src/db_cli.cr migrate seed
```

```bash
crystal ./src/app.cr
```

Open <http://localhost:3000/?query=poney%20crystal>

![web page](https://raw.githubusercontent.com/mamantoha/kemal_and_clear_sample_app/master/app.png)

## Contributing

1. Fork it (<https://github.com/mamantoha/kemal_and_clear_sample_app/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
