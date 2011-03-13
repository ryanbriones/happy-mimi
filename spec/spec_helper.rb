require "bundler/setup"
Bundler.require(:default, :development)

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '../lib'))
require "happy-mimi"