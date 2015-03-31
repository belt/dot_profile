source 'https://rubygems.org'

ruby '2.1.5'

gem 'sdoc', '~> 0.4.0', group: :doc
gem 'i18n'
gem 'activesupport-inflector'
gem 'popen4'

group :development do
  gem 'binding_of_caller', platforms: [:mri_21]
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'reek'
end

group :linux, :darwin do
  gem 'rb-inotify', require: false
end

group :linux, :windows do
  gem 'rb-fchange', require: false
end

group :darwin do
  gem 'rb-fsevent', require: false
  gem 'growl', require: false
end

group :linux do
  gem 'libnotify', require: false
end

group :windows do
  gem 'win32console', require: false
  gem 'rb-notifu', require: false
end

group :development, :test do
  gem 'pry-byebug'
  gem 'interactive_editor'
  gem 'awesome_print'
  gem 'dotenv'
end

group :test do
  gem 'rspec'
end
