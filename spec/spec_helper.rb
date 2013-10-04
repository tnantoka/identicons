require 'simplecov'
SimpleCov.start 

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'web')
require 'rspec'
require 'rack/test'

require 'fileutils'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  conf.before(:each) do
    FileUtils.rm_rf('./tmp')
  end

  conf.treat_symbols_as_metadata_keys_with_true_values = true
  conf.filter_run focus: true
  conf.run_all_when_everything_filtered = true
end
