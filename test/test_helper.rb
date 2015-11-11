require "minitest/spec"
require "minitest/autorun"
require "webmock/minitest"

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bitkassa"

class Minitest::Spec
  before do
    stubbed_request
  end

  protected

  def stubbed_request
    @stubbed_request ||= stub_request(:any, "https://www.bitkassa.nl/api/v1")
  end
end
