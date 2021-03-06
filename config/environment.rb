# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'
require 'byebug'
require 'pg'
require 'active_record'
require 'logger'
require 'twitter'
require 'sinatra'
require "sinatra/reloader" if development?

require 'erb'
require 'omniauth-twitter'

# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')

if Sinatra::Base.development?
  API_KEYS = YAML::load(File.open('config/token.yaml'))
else
  API_KEYS = {}
  API_KEYS["twitter_consumer_key_id"] = ENV["twitter_consumer_key_id"]
  API_KEYS["twitter_consumer_secret_key_id"] = ENV["twitter_consumer_secret_key_id"]
end

# # http://www.rubydoc.info/gems/twitter


use OmniAuth::Builder do
  provider :twitter, API_KEYS["twitter_consumer_key_id"], API_KEYS["twitter_consumer_secret_key_id"]
end