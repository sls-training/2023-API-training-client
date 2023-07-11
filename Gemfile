# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.0.6'

gem 'pg', '~> 1.5'
gem 'puma', '~> 6.3'

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'brakeman', '~> 6.0', require: false
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'faker', '~> 3.2'
  gem 'katakata_irb', github: 'tompng/katakata_irb', require: false
  gem 'rbs', '~> 3.1', require: false
  gem 'rbs_rails', '~> 0.12', require: false

  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-mocks', '~> 3.12'
  gem 'rspec-rails', '~> 6.0'

  gem 'rubocop', '~> 1.51', require: false
  gem 'rubocop-config-timedia', github: 'timedia/styleguide', glob: 'ruby/**/*.gemspec', require: false
  gem 'rubocop-erb', '~> 0.2.4', require: false
  gem 'rubocop-factory_bot', '~> 2.23', require: false
  gem 'rubocop-performance', '~> 1.18', require: false
  gem 'rubocop-rails', '~> 2.20', require: false
  gem 'rubocop-rspec', '~> 2.22', require: false
end

group :development do
  gem 'rspec-daemon', '~> 0.1', require: false
end

group :test do
  gem 'capybara', '~> 3.39'
  gem 'selenium-webdriver', '~> 4.10'
end
