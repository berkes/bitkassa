module Bitkassa
  class Config
    attr_accessor :secret_api_key,
                  :merchant_id,
                  :base_uri

    def initialize
      @base_uri = "https://www.bitkassa.nl/api/v1"
    end
  end
end
