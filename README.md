# mufo / Redmine

The redmine we use. 

### Things not included in this repo: 

- the Database
- /data/
- /log/
- /repo/
- /config/database.yml
- cache, tmp file, secret token...etc

## Installation

1. `git clone https://github.com/mufo/redmine.git`, `cd redmine`
2. configure the database: `cp config/database.yml.example config/database.yml ; vi config/database.yml`
3. get submodules: `git submodule init ; git submodule update`
4. `gem install bundler ; bundle install --without development test` (or rmagick)
5. if newly installation: create the database `RAILS_ENV=production rake db:migrate ; RAILS_ENV=production rake redmine:plugins`
6. restore old data: import database, restore email settings and copy `data/`, `repo/` from old server.
7. `rake generate_secret_token`
8. and there we go: `thin -C thincfg.yml start`