module Bitkassa
  class PaymentResponse
    attr_accessor :payment_id, :payment_status, :meta_info

    def self.from_json(json)
      new(JSON.parse(json))
    end

    def initialize(attributes)
      @payment_id     = attributes["payment_id"]
      @payment_status = attributes["payment_status"]
      @meta_info      = attributes["meta_info"]
    end
  end
end
