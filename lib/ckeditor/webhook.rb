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
      # @param  payload    [String]   the webhook's string payload
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

        Event.new(parse_payload(payload))
      end

      private

      # Returns the event's message for signing following CKEditor's rules.
      #
      # @see  https://ckeditor.com/docs/cs/latest/examples/security/request-signature-nodejs.html
      def message(method:, url:, timestamp:, payload:)
        uri    = URI.parse(url)
        path   = uri.path + (uri.query.nil? ? "" : "?#{uri.query}" )
        method = method.upcase
        body   = sanitize_payload(payload)

        "#{method}#{path}#{timestamp}#{body}"
      end

      def message_signature(message:, secret:)
        ::OpenSSL::HMAC.hexdigest(
          "SHA256",
          secret,
          message
        )
      end

      # Returns the string payload as a Hash with symbol keys.
      #
      # @return  [Hash]
      # @raise   JSON::ParserError  if JSON is invalid
      def parse_payload(payload)
        JSON.parse(payload, symbolize_names: true)
      end

      # Returns the string payload... as a string.
      #
      #   1. I remove any whitespace. The signature is generated from JSON
      #      without whitespace (e.g., '{"a":"ba"}'). Any unexpected spaces
      #      (e.g., '{ "a": "b" }') will cause a signature verification failure.
      #
      #   2. I avoid the `to_json` method. Rails ActiveSupport extends the
      #      method to encode HTML entities. For example, the "<" character is
      #      encoded to "\u003c"). The encoded payload does not match the
      #      original payload and will cause a signature verification failure.
      #
      # @return  [String]
      # @raise   JSON::ParserError  if JSON is invalid
      def sanitize_payload(payload)
        JSON.generate(JSON.parse(payload))
      end
    end
  end
end
