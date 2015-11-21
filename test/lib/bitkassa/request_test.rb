require "test_helper"

describe Bitkassa::Request do
  before do
    Bitkassa.config.secret_api_key = "SECRET"
    Bitkassa.config.merchant_id = "banketbakkerhenk"
    stubbed_request.to_return(body: {}.to_json)
  end

  describe "#perform" do
    it "signs the authenctication with the authenticator" do
      json = { json: true, action: "", merchant_id: "banketbakkerhenk" }.to_json
      Time.stub :now, Time.at(42).utc do
        subject
      end

      authenticator = Minitest::Mock.new
      authenticator.expect(:sign, "signature", [json, 42])
      subject.authenticator = authenticator

      subject.stub :json_payload, json do
        subject.perform
      end

      assert_requested :post,
                       "https://www.bitkassa.nl/api/v1",
                       body: /.*&a=signature/
      authenticator.verify
    end

    it "serializes the attributes with merchant_id and action" do
      json = { json: true, action: "", merchant_id: "banketbakkerhenk" }.to_json
      payload = Base64.urlsafe_encode64(json)

      subject.stub :attributes, json: true do
        subject.perform
      end

      assert_requested :post,
                       "https://www.bitkassa.nl/api/v1",
                       body: /^p=#{payload}.*$/
    end

    it "does not perform when can_perform? is false" do
      subject.stub(:can_perform?, false) do
        proc { subject.perform }.must_raise Bitkassa::Exception
      end
    end
  end

  describe "#can_perform?" do
    describe "when merchant_id is empty" do
      before { Bitkassa.config.merchant_id = "" }
      it { subject.can_perform?.must_equal false }
    end

    describe "when secret_api_key is empty" do
      before { Bitkassa.config.secret_api_key = "" }
      it { subject.can_perform?.must_equal false }
    end
  end

  describe "#attributes" do
    it "is an empty hash" do
      subject.attributes.must_equal({})
    end
  end

  private

  def subject
    @subject ||= Bitkassa::Request.new
  end
end
