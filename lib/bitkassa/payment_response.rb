module Bitkassa
  # A +PaymentResponse+ represents the immediate response after requesting a
  # payment. It can will parse the JSON and contain the information nessecary
  # to determine the status of the payment request.
  class PaymentResponse
    attr_accessor :payment_id,
                  :payment_url,
                  :address,
                  :amount,
                  :bitcoin_url,
                  :expire,
                  :error,
                  :success

    def self.from_json(json)
      new(JSON.parse(json))
    end

    def initialize(attributes)
      attributes.each do |key, value|
        setter_method = "#{key.to_s}=".to_sym
        self.send(setter_method, value)
      end
    end
  end
end
