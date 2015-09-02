$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

require 'rubygems'
require 'bundler/setup'
require 'dotenv'
Dotenv.load

require 'bitnami'
require 'sidekiq'
require 'pp'
require 'pry'

# threadsafe setup for aws-sdk gem
# https://forums.aws.amazon.com/thread.jspa?messageID=290781#290781
# Aws.eager_autoload!
