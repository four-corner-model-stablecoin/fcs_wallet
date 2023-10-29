# frozen_string_literal: true

module FCSWallet
  class VC
    attr_accessor :jwt

    def initialize(jwt)
      @jwt = jwt
    end

    def verify
      response = Net::HTTP.post(
        URI("#{ENV['DID_SERVICE_URL']}/vc/verify"),
        { "vcJwt": self.jwt }.to_json,
        'Content-Type' => 'application/json'
      )
      body = JSON.parse(response.body)

      {
        verify: body['verified'],
        vc: body['vc'],
        issuer_pubkey_jwk: body['issuerDid']['didDocument']['verificationMethod'][0]['publicKeyJwk'],
        holder_pubkey_jwk: body['holderDid']['didDocument']['verificationMethod'][0]['publicKeyJwk']
      }
    end
  end
end
