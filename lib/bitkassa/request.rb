module Bitkassa
  ##
  # Generic HTTP Request
  class Request
    # Override the class that is initialized to capture the +perform+ response.
    # Defaults to +Bitkassa::PaymentResponse+.
    attr_writer :responder

    # Overrides the default +Bitkassa::Authentication+ to sign the
    # authentication
    attr_writer :authenticator

    ## Initalize a request
    # * +attributes+ +Hash+
    def initialize(attributes = {})
      @initialized_at = Time.now.to_i
      assign_attributes(attributes)
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
    # Defines the attributes to be serialised in the payload
    # merchant_id and action will be merged by default.
    def attributes
      {}
    end

    ##
    # Defines the action to insert into the payload.
    def payload_action
      ""
    end

    def can_perform?
      return false if Bitkassa.config.merchant_id.nil?
      return false if Bitkassa.config.merchant_id.empty?
      return false if Bitkassa.config.secret_api_key.nil?
      return false if Bitkassa.config.secret_api_key.empty?
      true
    end

    protected

    def json_payload
      attributes.merge(
        action: payload_action,
        merchant_id: Bitkassa.config.merchant_id
      ).to_json
    end

    def assign_attributes(attributes)
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def responder
      @responder ||= Bitkassa::PaymentResponse
    end

    def authenticator
      @authenticator ||= Authentication
    end

    private

    def uri
      Bitkassa.config.base_uri
    end

    def params
      { p: payload, a: authentication }
    end

    def authentication
      authenticator.sign(json_payload, @initialized_at)
    end

    def payload
      Base64.urlsafe_encode64(json_payload)
    end

    def params_string
      params.map { |k, v| [k, "=", v].join }.join("&")
    end
  end
end
