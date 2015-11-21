require "test_helper"

describe Bitkassa::PaymentResponse do
  describe ".from_json" do
    it "parses the JSON and assigns attributes" do
      subject = Bitkassa::PaymentResponse.from_json(attributes.to_json)

      attributes.each do |key, value|
        subject.send(key).must_equal value
      end
    end

    it "parses error JSON and assigns error" do
      attributes = {
        error: "Missing amount",
        success: false
      }
      subject = Bitkassa::PaymentResponse.from_json(attributes.to_json)
      subject.error.must_equal "Missing amount"
    end
  end

  private

  def attributes
    @attributes ||= {
      payment_id: "dhqe4cnj7f",
      payment_url: "https://www.bitkassa.nl/tx/dhqe4cnj7f",
      address: "1BK9imjqeziWixvD64XfYNye5rKi2HcN7P",
      amount: "4430000",
      bitcoin_url: "bitcoin:1BK9imjqeziWixvD64XfYNye5rKi2HcN7P?amount=0.0443",
      expire: "1447264400",
      success: true
    }
  end
end
