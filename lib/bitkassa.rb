require "base64"
require "httpi"

module Bitkassa
  def self.config
    @config ||= Bitkassa::Config.new
  end
end

Dir["./lib/bitkassa/*.rb"].each { |file| require file }
