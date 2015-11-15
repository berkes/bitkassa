require "minitest/spec"
require "minitest/autorun"
require "webmock/minitest"

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bitkassa"

module Minitest
  class Spec
    WebMock.disable_net_connect!(allow: "codeclimate.com")

    before do
      stubbed_request
    end

    after do
      Bitkassa.config.debug = false
    end

    protected

    def stubbed_request
      @stubbed_request ||= stub_request(:any, "https://www.bitkassa.nl/api/v1")
    end
  end
end
