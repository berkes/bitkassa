require "json"
require "base64"
require "httpi"

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

Dir["./lib/bitkassa/*.rb"].each { |file| require file }
