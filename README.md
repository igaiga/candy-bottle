## version

* Ruby 2.2.x
* Rails 4.0.2

## setup

* $ bundle
* create config/database.yml from database.yml.example
* $ RAILS_ENV=production bundle exec rake db:create
* $ RAILS_ENV=production bundle exec rake db:migrate
* $ RAILS_ENV=production bundle exec rake db:seed

Input Pit settings when you run first time.
* $ RAILS_ENV=production bundle exec rails runner "TweetCollector.setup_pit"

* Target words are stored in targets table.

## Run

* $ RAILS_ENV=production bundle exec rails runner "TweetCollector.bring"
