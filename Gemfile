source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.0.2"
gem "puma", "~> 3.0"
gem "sass-rails", "~> 5.0"
gem "bootstrap-sass", "3.3.6"
gem "font-awesome-rails"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jquery-rails"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.5"
gem "redis", "~> 3.0"
gem "devise", "~> 4.2", ">= 4.2.1"
gem "rolify"
gem "cancan"
gem "pry", "~> 0.10.4"
gem "config"
gem "kaminari"
gem "simple_form", "~> 3.4"
gem "ransack", "~> 1.8", ">= 1.8.2"
gem "bootstrap-datepicker-rails"

group :development, :test do
  # Use mysql data
  gem "mysql2", ">= 0.3.18", "< 0.5"
  gem "byebug", platform: :mri
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.8"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :production do
  gem "pg", "0.18.4"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
