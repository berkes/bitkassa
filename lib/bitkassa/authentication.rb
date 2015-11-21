module Bitkassa
  ##
  # Authenticates a message.
  # Ensures that incoming requests originated at Bitkassa.
  # And signs our own requests so Bitkassa knows it was us who sent the request.
  class Authentication
    def self.sign(payload, sent_at)
      message = "#{Bitkassa.config.secret_api_key}#{payload}#{sent_at}"
      digest  = Digest::SHA256.hexdigest(message)
      "#{digest}#{sent_at}"
    end

    def self.valid?(signature, payload)
      sent_at = signature[64..-1]
      signature == sign(payload, sent_at)
    end
  end
end
