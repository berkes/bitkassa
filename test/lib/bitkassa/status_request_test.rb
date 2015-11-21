require "test_helper"

describe Bitkassa::StatusRequest do
  before do
    Bitkassa.config.secret_api_key = "SECRET"
    Bitkassa.config.merchant_id = "banketbakkerhenk"
  end

  describe "#attributes" do
    it "has payment_id" do
      attributes = {
        payment_id: "dhqe4cnj7f"
      }

      bitkassa = Bitkassa::StatusRequest.new(attributes)
      bitkassa.attributes.must_equal attributes
    end
  end

  describe "#payload_action" do
    it { subject.payload_action.must_equal "get_payment_status" }
  end

  describe "#can_perform?" do
    describe "when payment_id is empty" do
      before { subject.payment_id = nil }
      it { subject.can_perform?.must_equal false }
    end
    describe "when paymen_id is set" do
      before { subject.payment_id = "dhqe4cnj7f" }
      it { subject.can_perform?.must_equal true }
    end
  end

  private

  def subject
    @subject ||= Bitkassa::StatusRequest.new(payment_id: "dhqe4cnj7f")
  end
end
