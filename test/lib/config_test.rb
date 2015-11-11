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
end
