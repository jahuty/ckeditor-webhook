require "ckeditor/webhook/version"

require "ckeditor/webhook/event"

require "json"
require "openssl"
require "uri"

module Ckeditor
  module Webhook
    class Error < StandardError; end
    class SignatureVerificationError < StandardError; end

    class << self
      # Returns an Event if the webhook signature is valid.
      #
      # @param  secret     [String]   the CKEditor Cloud Services API secret
      # @param  payload    [Hash]     the webhook's payload as a hash
      # @param  signature  [String]   the request's `X-CS-Signature` header
      # @param  timestamp  [Integer]  the request's `X-CS-Timestamp` header
      # @param  method     [String]   the request's method (defaults to "POST")
      # @param  url        [String]   the request's url
      #
      # @raise  [SignatureVerificationError]  if signature's don't match
      #
      # @return  [Event]
      #
      def construct_event(secret:, payload:, signature:, timestamp:, url:, method: "POST")
        event = message(method: method, url: url, timestamp: timestamp, payload: payload)

        raise SignatureVerificationError if signature != message_signature(message: event, secret: secret)

        Event.new(payload)
      end

      private

      # Returns the event's message for signing following CKEditor's rules.
      #
      # @see  https://ckeditor.com/docs/cs/latest/examples/security/request-signature-nodejs.html
      def message(method:, url:, timestamp:, payload:)
        uri    = URI.parse(url)
        path   = uri.path + (uri.query.nil? ? "" : "?#{uri.query}" )
        method = method.upcase
        body   = payload.to_json

        "#{method}#{path}#{timestamp}#{body}"
      end

      def message_signature(message:, secret:)
        ::OpenSSL::HMAC.hexdigest(
          "SHA256",
          secret,
          message
        )
      end
    end
  end
end
