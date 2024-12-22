#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
rm -rf public/assets
RAILS_ENV=production bundle exec rails assets:precompile
bundle exec rails db:migrate