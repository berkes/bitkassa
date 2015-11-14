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
      subject.perform
      assert_requested :post,
                       "https://www.bitkassa.nl/api/v1",
                       body: "p=#{subject.payload}&a=#{subject.authentication}"
    end

    it "returns a Bitkassa::PaymentResponse initialized with response json" do
      stubbed_request.to_return(body: "response_json")
      expected = Bitkassa::PaymentResponse.new("response_json")
      subject.perform.must_be_instance_of Bitkassa::PaymentResponse
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
          "meta_info" => "ORDERID42"}

      parsed = JSON.parse(bitkassa.json_payload)
      parsed.must_equal(expected)
    end
  end

  describe "#authentication" do
    before do
      Bitkassa.config.secret_api_key = "SECRET"
    end

    # a = sha256( secret API key + json data + unixtime ) + unixtime
    it "is sha256 hash of api-key, payload and current unix time" do
      now = 42
      Time.stub :now, Time.at(now) do
        message = "SECRET#{subject.json_payload}#{now.to_s}"
        expected = Digest::SHA256.hexdigest(message)

        hash = subject.authentication[0...64]
        hash.must_equal expected
      end
    end

    it "adds current unix time to hash" do
      now = 42

      Time.stub :now, Time.at(now) do
        addition = subject.authentication[64..-1]
        addition.must_equal 42.to_s
      end
    end
  end

  private

  def subject
    @subject ||= Bitkassa::PaymentRequest.new("EUR", 1337)
  end
end
