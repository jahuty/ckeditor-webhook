# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.2.1 - 2020-10-31

- Remove "?" character from `path` if the URL's query string does not exist. This should fix signature verification errors for URLs without a query string.

## 0.2.0 - 2020-10-30

- Add `Event#id` method to return a hash based on the event's payload. Provided events' `sent_at` timestamps are separated by at least one millisecond, this should serve as a unique identifier.

## 0.1.0 - 2020-10-30

- Initial release
