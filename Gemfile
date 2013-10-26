# Gemfile

source 'https://rubygems.org'
ruby "2.0.0"

gem "sinatra" 
gem "sinatra-contrib"

gem 'activesupport'
gem "activerecord" 
gem "sinatra-activerecord"

gem 'thin'

gem 'rake'

gem 'shotgun'

group :test do
	gem 'faker'
	gem 'rspec'
end

group :development do
  gem 'sqlite3'
  gem "tux"
end

group :production do
  gem 'pg'
end
