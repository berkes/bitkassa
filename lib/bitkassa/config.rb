module Bitkassa
  ##
  # Contains the global configuration for the library.
  class Config
    # The Secret API key you received with your Bitkassa Account.
    attr_accessor :secret_api_key
    # The Merchant ID you received with your Bitkassa Account.
    attr_accessor :merchant_id
    # Base URI where all calls are redirected to. Defaults to
    # +https://www.bitkassa.nl/api/v1+.
    # Use when e.g. a proxy or self-hosted variant is used.
    attr_accessor :base_uri

    # Gets the current debug mode.
    attr_reader :debug

    # Sets defaults for the configuration.
    def initialize
      @base_uri = "https://www.bitkassa.nl/api/v1"
      self.debug = false
    end

    # Enable or disable debug mode. Boolean.
    def debug=(mode)
      @debug = mode

      if mode
        HTTPI.log = true
        HTTPI.log_level = :debug
      else
        HTTPI.log = false
      end
    end
  end
end
