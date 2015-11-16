module Bitkassa
  # A +PaymentResponse+ represents the immediate response after requesting a
  # payment. It can will parse the JSON and contain the information nessecary
  # to determine the status of the payment request.
  class PaymentResponse
    ##
    # Refer to +Initialize+ for the description of all attributes.
    attr_accessor :payment_id,
                  :payment_url,
                  :address,
                  :amount,
                  :bitcoin_url,
                  :expire,
                  :error,
                  :success
    ##
    # Generate a PaymentResponse from a JSON payload.
    def self.from_json(json)
      new(JSON.parse(json))
    end

    ##
    # Initialize a new payment response. Usually done by a +PaymentRequest+.
    #
    # Attributes:
    # * +payment_id+, Unique ID assigned to this payment by Bitkassa
    # * +payment_url+, The Bitcoin payment URL which you can show (as link
    #   and/or QR) for the customer to pay from his wallet (if you're hosting
    #   your own payment page) 
    # * +address+ The Bitcoin address where the customer is supposed to send
    #   his payment.
    # * +amount+, The amount in satoshis to be paid.
    # * +expire+, Unix timestamp when the payment expires (typically 15 
    #   minutes after start)
    # * +error+, Reason why the payment could not be initiated. Only set when
    #   payment errord. 
    # * +success+, Confirmation that the API call was processed successfull
    def initialize(attributes)
      attributes.each do |key, value|
        setter_method = "#{key}=".to_sym
        send(setter_method, value)
      end
    end
  end
end
