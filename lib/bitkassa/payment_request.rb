module Bitkassa
  class PaymentRequest
    def initialize(currency, amount)
      @currency = currency
      @amount = amount
      @initialized_at = Time.now.to_i
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
      { action: "start_payment",
        merchant_id: Bitkassa.config.merchant_id,
        currency: @currency,
        amount: @amount }.to_json
    end

    private

    def authentication_message
      "#{Bitkassa.config.secret_api_key}#{json_payload}#{@initialized_at}"
    end
  end
end
