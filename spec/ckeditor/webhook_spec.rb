RSpec.describe Ckeditor::Webhook do
  it "has a version number" do
    expect(Ckeditor::Webhook::VERSION).not_to be nil
  end

  # The success parameters and signature are taken from CKEdior's example
  # algorithm.
  #
  # @see  https://ckeditor.com/docs/cs/latest/examples/security/request-signature-nodejs.html
  describe "::construct_event" do
    let(:secret)    { "SECRET" }
    let(:method)    { "POST" }
    let(:url)       { "http://demo.example.com/webhook?a=1" }
    let(:timestamp) { 1563276169752 }
    let(:payload)   { { a: 1 } }

    context "when signatures do not match" do
      let(:signature) { "WRONG" }

      it "raises SignatureVerificationError exception" do
        expect {
          Ckeditor::Webhook.construct_event(
            url:       url,
            secret:    secret,
            method:    method,
            signature: signature,
            timestamp: timestamp,
            payload:   payload
          )
        }.to raise_error(Ckeditor::Webhook::SignatureVerificationError)
      end
    end

    context "when signatures do match" do
      let(:signature) { "56ac656c7f932c5b775be28949e90af9a2356eae2826539f10ab6526a0eec762" }

      it "returns event" do
        # Actually calling Event.new with payload will raise PayloadInvalid exception.
        expect(Ckeditor::Webhook::Event).to receive(:new).with(payload)

        Ckeditor::Webhook.construct_event(
          url:       url,
          secret:    secret,
          method:    method,
          signature: signature,
          timestamp: timestamp,
          payload:   payload
        )
      end
    end
  end
end
