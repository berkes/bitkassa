# Ruby interface to the Bitkassa API

[![Code Climate](https://codeclimate.com/github/berkes/bitkassa/badges/gpa.svg)](https://codeclimate.com/github/berkes/bitkassa)
[![Test Coverage](https://codeclimate.com/github/berkes/bitkassa/badges/coverage.svg)](https://codeclimate.com/github/berkes/bitkassa/coverage)
[![Build Status](https://travis-ci.org/berkes/bitkassa.svg)](https://travis-ci.org/berkes/bitkassa)

## API documentation

API documentation for this gem can be found [on rubydoc.info](http://www.rubydoc.info/github/berkes/bitkassa)

Documentation on the actual API can be found at [bitkassa](https://www.bitkassa.nl/api/documentatie). This is in Dutch.

## Usage summary

### Setup Config.

    Bitkassa.config.secret_api_key = "SECRET"
    Bitkassa.config.merchant_id = "banketbakkerhenk"

### Ininitialize, validate and perform a request

    attributes = {
      currency: "EUR",
      amount: 1337,
      description: "Description",
      return_url: "http://example.com/return",
      update_url: "http://example.com/update",
      meta_info: "ORDERID42"
    }

    bitkassa = Bitkassa::PaymentRequest.new(attributes) #=> PaymentRequest
    bitkassa.can_perform? #=> true
    response = bitkassa.perform #=> PaymentResponse
    response.payment_id #=> hAck1337
    response.payment_url #=> https://www.bitkass.nl/tx/hAck1337
