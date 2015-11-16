module Bitkassa
  ##
  # Make a PaymentRequest.
  #
  # This will return the payment-response whith all returned information.
  # A payment-request consists of a payload containing the information for the
  # payment and an authentication message, being a signed version of the
  # payload.
  class PaymentRequest
    ##
    # Override the class that is initialized to capture the +perform+ response.
    # Defaults to +Bitkassa::PaymentResponse+.
    attr_writer :responder

    ##
    # Initialize a +PaymentRequest+.
    #
    # * +currency+ +String+ "EUR" or "BTC"
    # * +amount+ +Integer+ amount to be paid in cents or satoshis
    # * +optionals+ +Hash+, description, return_url, update_url and meta_info
    def initialize(currency, amount, optionals = {})
      @currency = currency
      @amount = amount
      @initialized_at = Time.now.to_i
      assign_optionals(optionals)
    end

    ##
    # Make the request.
    #
    # returns +Bitkassa::PaymentResponse+ Regardless of the response, this
    # this PaymentResponse is initialized.
    #
    # When a payment cannot be made because of incorrect or missing data,
    # a +Bitkassa::Exception+ is raised.
    def perform
      if can_perform?
        response = HTTPI.post(uri, params_string)
        responder.from_json(response.body)
      else
        fail Bitkassa::Exception,
             "Your merchant_id or merchant_key are not set"
      end
    end

    ##
    # returns the +base_64+ encoded JSON as string.
    def payload
      Base64.urlsafe_encode64(json_payload)
    end

    ##
    # returns the authentication message as string.
    def authentication
      Digest::SHA256.hexdigest(authentication_message) + @initialized_at.to_s
    end

    ##
    # returns JSON representation of the payload as string.
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
