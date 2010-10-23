# This file is used by Rack-based servers to start the application.
$KCODE = 'u'
require ::File.expand_path('../config/environment',  __FILE__)

use Rack::RawUpload, :paths => ['/admin*upload*']
run MahaMandala::Application
