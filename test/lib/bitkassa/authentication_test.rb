require "test_helper"

describe Bitkassa::Authentication do
  before do
    Bitkassa.config.secret_api_key = "SECRET"
  end

  describe ".sign" do
    # a = sha256( secret API key + json data + unixtime ) + unixtime
    it "is sha256 hash of api-key, payload and current unix time" do
      hash = Bitkassa::Authentication.sign("PAYLOAD", 42)[0...64]
      hash.must_equal asserted_digest
    end

    it "adds current unix time to hash" do
      addition = Bitkassa::Authentication.sign("PAYLOAD", 42)[64..-1]
      addition.must_equal 42.to_s
    end
  end

  describe ".valid?" do
    it "matches signature with a self signed version of payload" do
      Bitkassa::Authentication.valid?(asserted_signature, "PAYLOAD")
    end
  end

  private

  def asserted_message
    "SECRETPAYLOAD42"
  end

  def asserted_digest
    Digest::SHA256.hexdigest(asserted_message)
  end

  def asserted_signature
    "#{asserted_digest}42"
  end
end
