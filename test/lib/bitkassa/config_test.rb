require "test_helper"

describe Bitkassa::Config do
  describe "secret_api_key" do
    it "is settable" do
      Bitkassa.config.secret_api_key = "SECRET"
      Bitkassa.config.secret_api_key.must_equal "SECRET"
    end
  end

  describe "merchant_id" do
    it "is settable" do
      Bitkassa.config.merchant_id = "banketbakkerhenk"
      Bitkassa.config.merchant_id.must_equal "banketbakkerhenk"
    end
  end

  describe "base_uri" do
    it "defaults to api url" do
      Bitkassa.config.base_uri.must_equal "https://www.bitkassa.nl/api/v1"
    end
  end

  describe "debug" do
    it "defaults to false" do
      Bitkassa.config.debug.must_equal false
    end

    it "is settable" do
      Bitkassa.config.debug = true
      Bitkassa.config.debug.must_equal true
    end

    it "sets httpi log" do
      Bitkassa.config.debug = false
      HTTPI.log?.must_equal false
    end
  end
end
