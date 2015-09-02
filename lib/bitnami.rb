require 'rubygems'
require 'bundler/setup'
require 'dotenv'
Dotenv.load

require 'bitnami/ec2'
require 'bitnami/wordpress'
require 'workers/wordpress_status'

module Bitnami
end
