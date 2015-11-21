module Bitkassa
  ##
  # Make a PaymentRequest.
  #
  # This will return the payment-response whith all returned information.
  # A payment-request consists of a payload containing the information for the
  # payment and an authentication message, being a signed version of the
  # payload.
  class PaymentRequest < Request
    attr_accessor :currency,
                  :amount,
                  :description,
                  :return_url,
                  :update_url,
                  :meta_info
    ##
    # Attributes for the payload
    #
    # * +attributes+ +Hash+:
    # ** +currency+ +String+ required. "EUR" or "BTC"
    # ** +amount+ +Integer+ required, amount to be paid in cents or satoshis
    # ** +description+,
    # ** +return_url+,
    # ** +update_url+,
    # ** +meta_info+
    def attributes
      {
        currency: @currency,
        amount: @amount,
        description: @description,
        return_url: @return_url,
        update_url: @update_url,
        meta_info: @meta_info
      }
    end

    ##
    # Override can_perform the require "currency" and "amount"
    def can_perform?
      return false if currency.nil?
      return false if amount.nil?
      super
    end

    ##
    # Payload action is "start_payment"
    def payload_action
      "start_payment"
    end
  end
end
