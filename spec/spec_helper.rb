# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

unless defined?(FIXTURE_PATH)
  FIXTURE_PATH = File.join(File.dirname(__FILE__), '/fixtures')
  SCRATCH_PATH = File.join(File.dirname(__FILE__), '/tmp')

  TEST_SERVER = CouchRest.new('http://faust45:cool@192.168.1.100:5984')
  TESTDB    = 'test_roks'
  TEST_SERVER.default_database = TESTDB
  I_DB = TEST_SERVER.database(TESTDB)
end

class BaseModel
  use_database TEST_SERVER.default_database
end

Rspec.configure do |config|
  #config.before(:all) { reset_test_db! }
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :flexmock

  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true
end


def reset_test_db!
  I_DB.recreate! rescue nil 
  I_DB
end

def loggin_as(user)
  @controller.stub!(:current_user).and_return(user)
end
