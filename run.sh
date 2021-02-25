#rvm use 2.6.4
bundle install --without production
bundle exec rake db:setup
rails server -p $PORT -b $IP
