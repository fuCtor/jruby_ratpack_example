require 'rubygems'

ENV['RACK_ENV']        = 'test'

require_relative '../config/bootstrap'

if ENV['TRAVIS_CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/.bundle/'
    add_filter '/.jbundler/'
  end
end



RSpec.configure do |config|
  # Mock Framework
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
