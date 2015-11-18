require "json"
require "base64"
require "httpi"

require_relative "bitkassa/authentication"
require_relative "bitkassa/request"
require_relative "bitkassa/config"
require_relative "bitkassa/exception"
require_relative "bitkassa/payment_request"
require_relative "bitkassa/status_request"
require_relative "bitkassa/payment_response"
require_relative "bitkassa/payment_result"

##
# Bitkassa Namespace
module Bitkassa
  ##
  # Intiialize and access the +Bitkassa::Config+.
  #
  #    Bitkassa.config.base_uri = "http://local.proxy/"
  def self.config
    @config ||= Bitkassa::Config.new
  end
end
