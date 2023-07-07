# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.0.6'

gem 'pg', '~> 1.5'
gem 'puma', '~> 6.3'

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'rubocop', '~> 1.51', require: false
  gem 'rubocop-config-timedia', github: 'timedia/styleguide', glob: 'ruby/**/*.gemspec', require: false
  gem 'rubocop-factory_bot', '~> 2.23', require: false
  gem 'rubocop-performance', '~> 1.18', require: false
  gem 'rubocop-rails', '~> 2.20', require: false
  gem 'rubocop-rspec', '~> 2.22', require: false
end
