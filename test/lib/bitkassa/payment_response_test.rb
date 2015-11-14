require "test_helper"

describe Bitkassa::PaymentResponse do
  describe ".from_json" do
    it "parses the JSON and assigns attributes" do
      subject = Bitkassa::PaymentResponse.from_json(json)
      subject.payment_id.must_equal "ID"
      subject.payment_status.must_equal "STATUS"
      subject.meta_info.must_equal "ORDERID42"
    end
  end

  private
  def json
    @json ||= {
      payment_id: "ID",
      payment_status: "STATUS",
      meta_info: "ORDERID42"
    }.to_json
  end
end
