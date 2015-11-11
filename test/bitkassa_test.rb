require "test_helper"

describe Bitkassa do
  describe ".config" do
    it "is a Bitkassa::Config" do
      Bitkassa.config.must_be_instance_of Bitkassa::Config
    end
    it "is a singleton" do
      expected = Bitkassa.config
      Bitkassa.config.must_be_same_as expected
    end
  end
end
