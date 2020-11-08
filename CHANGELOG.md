# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.3.0 - 2020-11-09

- Change the `payload` keyword argument to `Ckeditor::Webhook.construct_event` from a `Hash` to a `String`. We can parse the JSON Rather than requiring callers to do so.
- Change the internals to avoid the `to_json` method. Rails' [ActiveSupport::Hash](https://github.com/rails/activesupport-json_encoder/blob/master/lib/active_support/json/encoding/active_support_encoder.rb) appears to extend `to_json` to encode certain characters in HTML. Since the encoded payload does not equal the original payload, the signature verification fails.

## 0.2.1 - 2020-10-31

- Remove "?" character from `path` if the URL's query string does not exist. This should fix signature verification errors for URLs without a query string.

## 0.2.0 - 2020-10-30

- Add `Event#id` method to return a hash based on the event's payload. Provided events' `sent_at` timestamps are separated by at least one millisecond, this should serve as a unique identifier.

## 0.1.0 - 2020-10-30

- Initial release
