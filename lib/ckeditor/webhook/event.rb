require "time"
require "digest"
require "json"

# A generic webhook notification from Ckeditor Cloud Services.
#
# @see  https://ckeditor.com/docs/cs/latest/guides/webhooks/overview.html
module Ckeditor
  module Webhook
    class InvalidPayload < StandardError; end

    class Event
      PROPERTIES = %i[event environment_id payload sent_at]

      # @raise  [InvalidPayload]  raised if required properties are missing
      def initialize(payload)
        raise InvalidPayload.new(
          "Expected a hash with :#{PROPERTIES.join(", :")} keys"
        ) unless PROPERTIES.all? { |s| payload.key? s }

        @payload = payload
      end

      def environment_id
        @payload[:environment_id]
      end

      def id
        Digest::SHA2.hexdigest @payload.to_json
      end

      def payload
        @payload[:payload]
      end

      def sent_at
        ::Time.parse @payload[:sent_at]
      end

      def type
        @payload[:event]
      end
    end
  end
end
