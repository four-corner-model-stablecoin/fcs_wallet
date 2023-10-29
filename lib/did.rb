# frozen_string_literal: true

module FCSWallet
  class DID
    attr_accessor :short
    attr_accessor :long
    attr_accessor :jwk

    def initialize(short: nil, long: nil, jwk: nil)
      @short = short
      @long = long
      @jwk = jwk
    end

    def self.generate
      response = Net::HTTP.post(
        URI("#{ENV['DID_SERVICE_URL']}/did/create"),
        { "services": [] }.to_json,
        'Content-Type' => 'application/json'
      )
      body = JSON.parse(response.body)

      long  = body['did']
      jwk = body['signingKey']['privateJwk']
      new(long: , jwk: )
    end
  end
end
