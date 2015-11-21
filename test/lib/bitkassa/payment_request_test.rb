require "test_helper"

describe Bitkassa::PaymentRequest do
  before do
    Bitkassa.config.secret_api_key = "SECRET"
    Bitkassa.config.merchant_id = "banketbakkerhenk"
  end

  describe "#attributes" do
    it "has currency, money, description, return_url, update_url, meta_info" do
      attributes = {
        currency: "EUR",
        amount: 1337,
        description: "Description",
        return_url: "http://example.com/return",
        update_url: "http://example.com/update",
        meta_info: "ORDERID42"
      }

      bitkassa = Bitkassa::PaymentRequest.new(attributes)
      bitkassa.attributes.must_equal attributes
    end
  end

  describe "#payload_action" do
    it { subject.payload_action.must_equal "start_payment" }
  end

  describe "#may_perform?" do
    describe "when currency is empty" do
      before { subject.currency = nil }
      it { subject.can_perform?.must_equal false }
    end

    describe "when amount is empty" do
      before { subject.amount = nil }
      it { subject.can_perform?.must_equal false }
    end
  end

  private

  def subject
    @subject ||= Bitkassa::PaymentRequest.new(currency: "EUR", amount: 1337)
  end
end
