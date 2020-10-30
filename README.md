[![CircleCI](https://circleci.com/gh/jahuty/ckeditor-webhook.svg?style=svg)](https://circleci.com/gh/jahuty/ckeditor-webhook)

# Ckeditor Webhook

A gem for handling [webhooks](https://ckeditor.com/docs/cs/latest/guides/webhooks/overview.html#webhook-format) from CKEditor Cloud Services.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ckeditor-webhook'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install ckeditor-webhook
```

## Usage

Call `Ckeditor::Webhook::construct_event` with the following keyword arguments to create a verified webhook event (if the webhook is invalid, a `Ckedior::Webhook::SignatureVerificationError` will be raised):

- `secret` (`String`), the CKEditor Cloud Services [API secret](https://ckeditor.com/docs/cs/latest/guides/security/api-secret.html).
- `payload` (`Hash`), the webhook's payload
- `signature` (`String`), the request's `X-CS-Signature` header
- `timestamp` (`Integer`), the request's `X-CS-Timestamp` header
- `url` (`String`), the request's url
- `method` (`String`), the request's case-insensitive method (defaults to `"POST"`)

For example:

```ruby
# Store your CKEditor Cloud Services API key safely.
secret = "SECRET"

payload = JSON.parse(request.body.read, symbolize_names: true)
# => { event: "foo", environment_id: "bar", payload: { baz: "qux" }, sent_at: Time.now.utc }

url = request.original_url
# => "http://demo.example.com/webhook?a=1"

signature = request.env['X-CS-Signature']
# => "880558bfda70c698099ca1184a0c5c5114e5d91cc254d2532470eecf44819b94"

timestamp = request.env['X-CS-Timestamp']
# => 1563276169752

begin
  event = CKEditor::Webhook.construct_event(
    secret:    secret,
    payload:   payload,
    url:       url,
    signature: signature,
    timestamp: timestamp
  )

  event.type            # => "foo"
  event.environment_id  # => "bar"
  event.payload         # => { baz: "qux" }
  event.sent_at         # => Time
rescue Ckeditor::Webhook::SignatureVerificationError => e
  # Reject the webhook! The signature did not match.
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ckeditor-webhook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/ckeditor-webhook/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ckeditor::Webhook project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ckeditor-webhook/blob/master/CODE_OF_CONDUCT.md).
