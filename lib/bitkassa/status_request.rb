module Bitkassa
  # Checks the status of a payment
  class StatusRequest < Request
    attr_accessor :payment_id

    def attributes
      { payment_id: @payment_id }
    end

    def payload_action
      "get_payment_status"
    end

    def can_perform?
      return false if payment_id.nil?

      super
    end
  end
end
