require "test_helper"

describe Bitkassa::PaymentResult do
  describe ".from_form_urlencoded" do
    it "parses form encoded params p and a" do
      encoded = "p=payload&a=authentication"
      subject = Bitkassa::PaymentResult.from_form_urlencoded(encoded)
      subject.raw_payload.must_equal "payload"
      subject.raw_authentication.must_equal "authentication"
    end
  end

  describe "attributes" do
    before do
      @subject = Bitkassa::PaymentResult.new({})

      payload = {
        payment_id: "dhqe4cnj7f",
        payment_status: "pending",
        meta_info: "ORDERID42"
      }
      @subject.raw_payload = Base64.encode64(payload.to_json)
    end

    describe "#payment_id" do
      it { @subject.payment_id.must_equal "dhqe4cnj7f" }
    end

    describe "#payment_status" do
      it { @subject.payment_status.must_equal "pending" }
    end

    describe "#meta_info" do
      it { @subject.meta_info.must_equal "ORDERID42" }
      it "is nil when not in return" do
        payload = {
          payment_id: "dhqe4cnj7f",
          payment_status: "pending",
        }
        @subject.raw_payload = Base64.encode64(payload.to_json)
        @subject.meta_info.must_be_nil
      end
    end
  end

  describe "#valid?" do
    before do
      @secret = "SECRET"
      Bitkassa.config.secret_api_key = @secret
      @payload = { payload: "data" }.to_json
    end

    describe "with JSON payload and authentication set" do
      it "requests authentication at Authentication class" do
        Bitkassa::Authentication.stub :valid?, true do
          subject.valid?.must_equal true
        end
      end
    end

    describe "with missing secret_api_key" do
      before { Bitkassa.config.secret_api_key = nil }
      it { subject.valid?.must_equal false }
    end

    describe "with missing payload" do
      before { subject.raw_payload = nil }
      it { subject.valid?.must_equal false }
    end

    describe "with missing authentication" do
      before { subject.raw_authentication = nil }
      it { subject.valid?.must_equal false }
    end

    describe "with invalid json in payload" do
      before do
        @payload = Base64.encode64("not json")
      end

      it { subject.valid?.must_equal false }
    end
  end

  private

  def subject
    @subject ||= Bitkassa::PaymentResult.new(
      raw_authentication: asserted_digest(@secret, @payload),
      raw_payload: Base64.encode64(@payload)
    )
  end

  def asserted_digest(secret_api_key, payload)
    initialized_at = "42"
    Digest::SHA256.hexdigest(
      "#{secret_api_key}#{payload}#{initialized_at}"
    ) + initialized_at
  end
end
