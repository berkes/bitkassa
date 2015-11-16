require "test_helper"

describe Bitkassa::PaymentRequest do
  before do
    Bitkassa.config.secret_api_key = "SECRET"
    Bitkassa.config.merchant_id = "banketbakkerhenk"
  end

  it "requires merchant_id, currency and amount" do
    # Don't raise anything
    Bitkassa::PaymentRequest.new("EUR", 1337)
    proc do
      Bitkassa::PaymentRequest.new("EUR")
    end.must_raise ArgumentError
  end

  describe "#perform" do
    it "calls endpoint with payload and authentication" do
      Time.stub :now, Time.at(42).utc do
        subject
      end

      authenticator = Minitest::Mock.new
      authenticator.expect(:sign, "signature", [subject.json_payload, 42])
      responder = Minitest::Mock.new
      responder.expect(:from_json, nil, [""])

      subject.authenticator = authenticator
      subject.responder = responder
      Base64.stub :urlsafe_encode64, "payload" do
        subject.perform
      end
      assert_requested :post,
                       "https://www.bitkassa.nl/api/v1",
                       body: "p=payload&a=signature"
      responder.verify
      authenticator.verify
    end

    it "returns a Bitkassa::PaymentResponse initialized with response json" do
      responder = Minitest::Mock.new
      responder.expect(:from_json, nil, ["response_json"])
      subject.responder = responder

      stubbed_request.to_return(body: "response_json")
      subject.perform
      responder.verify
    end

    it "does not perform when merchant_id is empty" do
      Bitkassa.config.merchant_id = ""
      proc { subject.perform }.must_raise Bitkassa::Exception
    end

    it "does not perform when secret_api_key is empty" do
      Bitkassa.config.secret_api_key = ""
      proc { subject.perform }.must_raise Bitkassa::Exception
    end
  end

  describe "#payload" do
    it "is base64 encoded JSON with action merchant_id currency and amount" do
      expected = {
        "action" => "start_payment",
        "merchant_id" => "banketbakkerhenk",
        "currency" => "EUR",
        "amount" => 1337 }

      decoded = Base64.decode64(subject.payload)
      parsed = JSON.parse(decoded)
      parsed.must_equal(expected)
    end
  end

  describe "#json_payload" do
    it "is JSON with action merchant_id currency and amount" do
      expected = {
        "action" => "start_payment",
        "merchant_id" => "banketbakkerhenk",
        "currency" => "EUR",
        "amount" => 1337 }

      parsed = JSON.parse(subject.json_payload)
      parsed.must_equal(expected)
    end

    it "allows description, return_url, update_url and meta_info args" do
      bitkassa = Bitkassa::PaymentRequest.new(
        "EUR", 1337,
        description: "Description",
        return_url: "http://example.com/return",
        update_url: "http://example.com/update",
        meta_info: "ORDERID42")

      expected = {
        "action" => "start_payment",
        "merchant_id" => "banketbakkerhenk",
        "currency" => "EUR",
        "amount" => 1337,
        "description" => "Description",
        "return_url" => "http://example.com/return",
        "update_url" => "http://example.com/update",
        "meta_info" => "ORDERID42"
      }

      parsed = JSON.parse(bitkassa.json_payload)
      parsed.must_equal(expected)
    end
  end

  private

  def subject
    @subject ||= Bitkassa::PaymentRequest.new("EUR", 1337)
  end
end
