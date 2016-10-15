require 'rubygems'
require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'

require 'jbundler'

Bundler.setup(:default, ENV['RACK_ENV'])

require 'active_support/core_ext/object'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'

require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'

require 'jrjackson'
require 'jruby/core_ext'

begin
  require 'pry'
rescue LoadError
end

ROOT = File.expand_path './../../', __FILE__

$LOAD_PATH << File.join(ROOT, 'app')

# Load provided variables for using in configuration later
require 'dotenv'
Dotenv.load

begin
  require_relative "environments/#{ENV['RACK_ENV']}"
rescue LoadError
end

require "#{ROOT}/app/url_expander"

Dir[File.join(ROOT, 'config/initializers/*.rb')].to_a.sort.each do |initializer|
  require initializer
end