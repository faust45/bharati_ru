source 'http://rubygems.org/'

git 'git://github.com/plataformatec/simple_form.git' do
  gem 'simple_form'
end

gem 'activesupport',     '= 3.0.0', :require => 'active_support'
gem 'activemodel',       '= 3.0.0', :require => 'active_model'
gem 'actionpack',        '= 3.0.0', :require => 'action_pack'
gem 'railties',          '= 3.0.0', :require => 'rails'
gem 'actionmailer',      '= 3.0.0', :require => 'action_mailer'

gem 'validatable'
gem 'mini_magick'

gem 'mongrel'
#gem 'thin'
gem 'hirb'
gem 'wirble'
gem 'abstract'
gem 'builder'
gem 'ruby-mp3info', :require => 'mp3info'


gem 'ruby-debug'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'mime-types'


gem 'couchrest'
gem 'couchrest_extended_document'
gem 'couchrest_model'
gem 'json_pure'
gem 'rest-client'
gem 'fastercsv'

git 'http://github.com/mislav/will_paginate.git', :branch => 'rails3' do
  gem 'will_paginate', :require => 'will_paginate'
end

source 'http://gems.github.com'
gem 'i18n'

git 'http://github.com/yaroslav/russian.git' do
  gem 'russian', :require => 'russian'
end

gem 'tzinfo'

##git 'git://github.com/rspec/rspec.git' do
##git 'git://github.com/rspec/rspec-core.git'
##git 'git://github.com/rspec/rspec-expectations.git'
##git 'git://github.com/rspec/rspec-mocks.git'
##git 'git://github.com/rspec/rspec-rails.git'
#
git 'git://github.com/rtomayko/rack-cache.git' do
  gem 'rack-cache'
end

git 'git://github.com/markevans/dragonfly.git' do
  gem 'dragonfly'
end
#
group(:test) do
  git "git://github.com/rspec/rspec-rails.git" do
    gem "rspec-rails"
  end

  git "git://github.com/rspec/rspec.git" do
    gem "rspec"
  end

  git "git://github.com/rspec/rspec-core.git" do
    gem "rspec-core"
  end

  git "git://github.com/rspec/rspec-expectations.git" do
    gem "rspec-expectations"
  end

  git "git://github.com/rspec/rspec-mocks.git" do
    gem "rspec-mocks"
  end

  gem 'flexmock'
end
