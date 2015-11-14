module Bitkassa
  class Config
    attr_accessor :secret_api_key,
                  :merchant_id,
                  :base_uri

    attr_reader   :debug

    def initialize
      @base_uri = "https://www.bitkassa.nl/api/v1"
      self.debug = false
    end

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
