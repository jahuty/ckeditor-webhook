module Ckeditor
  module Webhook
    RSpec.describe Event do
      # @see  https://ckeditor.com/docs/cs/latest/guides/webhooks/overview.html#webhook-format
      let(:payload) do
        {
          event:          "foo",
          environment_id: "bar",
          payload:        { baz: "qux" },
          sent_at:        Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
        }
      end

      describe "#initialize" do
        context "when :event key is missing" do
          before { payload.delete :event }

          it "raises exception" do
            expect {
              Event.new(payload)
            }.to raise_error(InvalidPayload)
          end
        end

        context "when :environment_id key is missing" do
          before { payload.delete :environment_id }

          it "raises exception" do
            expect {
              Event.new(payload)
            }.to raise_error(InvalidPayload)
          end
        end

        context "when :payload key is missing" do
          before { payload.delete :payload }

          it "raises exception" do
            expect {
              Event.new(payload)
            }.to raise_error(InvalidPayload)
          end
        end

        context "when :sent_at key is missing" do
          before { payload.delete :sent_at }

          it "raises exception" do
            expect {
              Event.new(payload)
            }.to raise_error(InvalidPayload)
          end
        end

        context "when required keys are present" do
          it "returns event" do
            expect(Event.new(payload)).to be_instance_of(Event)
          end
        end
      end

      describe "#environment_id" do
        let(:event) { Event.new(payload) }

        it "returns environment_id" do
          expect(event.environment_id).to eq(payload[:environment_id])
        end
      end

      describe "#id" do
        let(:event) { Event.new(payload) }

        it "returns sha-256" do
          expect(event.id).to eq(Digest::SHA2.hexdigest payload.to_json)
        end
      end

      describe "#payload" do
        let(:event) { Event.new(payload) }

        it "returns payload" do
          expect(event.payload).to eq(payload[:payload])
        end
      end

      describe "#sent_at" do
        let(:event) { Event.new(payload) }

        it "returns a Time" do
          expect(event.sent_at).to be_instance_of(::Time)
        end

        it "returns parsed time" do
          expect(event.sent_at).to be_within(1).of Time.now
        end
      end

      describe "#type" do
        let(:event) { Event.new(payload) }

        it "returns type" do
          expect(event.type).to eq(payload[:event])
        end
      end
    end
  end
end
