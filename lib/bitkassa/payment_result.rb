module Bitkassa
  # A +PaymentResult+ represents the result which is posted to return_url.
  # This callback contains the status of the payment.
  class PaymentResult
    attr_accessor :raw_payload,
                  :raw_authentication

    def self.from_form_urlencoded(body)
      params = Hash[URI.decode_www_form(body)]
      new(raw_payload: params["p"], raw_authentication: params["a"])
    end

    def initialize(attributes)
      attributes.each do |key, value|
        setter_method = "#{key}=".to_sym
        send(setter_method, value)
      end
    end

    def payment_id
      payload["payment_id"]
    end

    def payment_status
      payload["payment_status"]
    end

    def meta_info
      payload["meta_info"]
    end

    def valid?
      return false if raw_payload.nil? || raw_payload.empty?
      return false if raw_authentication.nil? || raw_authentication.empty?
      return false unless json_valid?

      raw_authentication == expected_authentication
    end

    private

    def payload
      @payload ||= JSON.parse(json_payload)
    end

    def json_payload
      Base64.decode64(raw_payload)
    end

    def expected_authentication
      Digest::SHA256.hexdigest(
        "#{Bitkassa.config.secret_api_key}#{json_payload}#{sent_at}"
      ) + sent_at
    end

    def sent_at
      raw_authentication[64..-1]
    end

    def json_valid?
      begin
        payload
      rescue JSON::ParserError
        return false
      end
      true
    end
  end
end
