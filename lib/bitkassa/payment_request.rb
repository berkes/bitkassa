module Bitkassa
  class PaymentRequest
    attr_writer :responder

    def initialize(currency, amount, optionals = {})
      @currency = currency
      @amount = amount
      @initialized_at = Time.now.to_i
      assign_optionals(optionals)
    end

    def perform
      if can_perform?
        response = HTTPI.post(uri, params_string)
        responder.from_json(response.body)
      else
        fail Bitkassa::Exception,
             "Your merchant_id or merchant_key are not set"
      end
    end

    def payload
      Base64.urlsafe_encode64(json_payload)
    end

    def authentication
      Digest::SHA256.hexdigest(authentication_message) + @initialized_at.to_s
    end

    def json_payload
      base = {
        action: "start_payment",
        merchant_id: Bitkassa.config.merchant_id,
        currency: @currency,
        amount: @amount
      }

      base.merge(@optionals).to_json
    end

    private

    def uri
      Bitkassa.config.base_uri
    end

    def params
      { p: payload, a: authentication }
    end

    def assign_optionals(optionals)
      @optionals = {}

      [:description, :return_url, :update_url, :meta_info].each do |key|
        @optionals[key] = optionals[key] if optionals.key?(key)
      end
    end

    def authentication_message
      "#{Bitkassa.config.secret_api_key}#{json_payload}#{@initialized_at}"
    end

    def responder
      @responder ||= Bitkassa::PaymentResponse
    end

    def can_perform?
      return false if Bitkassa.config.merchant_id.nil?
      return false if Bitkassa.config.merchant_id.empty?
      return false if Bitkassa.config.secret_api_key.nil?
      return false if Bitkassa.config.secret_api_key.empty?
      true
    end

    def params_string
      params.map { |k, v| [k, "=", v].join }.join("&")
    end
  end
end
