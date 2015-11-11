module Bitkassa
  class PaymentRequest
    def initialize(currency, amount, optionals = {})
      @currency = currency
      @amount = amount
      @initialized_at = Time.now.to_i
      assign_optionals(optionals)
    end

    def call
      uri = URI.parse('https://www.bitkassa.nl/api/v1')
      req = Net::HTTP::Post.new(uri.path)
      res = Net::HTTP.start(uri.host, use_ssl: true) do |http|
        http.request(req, "p=#{payload}&a=authentication")
      end
    end

    def payload
      Base64.encode64(json_payload)
    end

    def authentication
      Digest::SHA256.hexdigest(authentication_message) + @initialized_at.to_s
    end

    def json_payload
      base = { action: "start_payment",
        merchant_id: Bitkassa.config.merchant_id,
        currency: @currency,
        amount: @amount }

      base.merge(@optionals).to_json
    end

    private

    def assign_optionals(optionals)
      @optionals = {}

      [:description, :return_url, :update_url, :meta_info].each do |key|
        @optionals[key] = optionals[key] if optionals.has_key?(key)
      end
    end

    def authentication_message
      "#{Bitkassa.config.secret_api_key}#{json_payload}#{@initialized_at}"
    end
  end
end
