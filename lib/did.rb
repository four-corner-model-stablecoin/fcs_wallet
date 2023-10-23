# frozen_string_literal: true

class Did
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
      URI("#{ENV['DID_SERVICE_SCHEMA']}://#{ENV['DID_SERVICE_HOST']}:#{ENV['DID_SERVICE_PORT']}/did/create"),
      { "services": [] }.to_json,
      'Content-Type' => 'application/json'
    )
    body = JSON.parse(response.body)

    binding.irb

    long  = body['did']
    jwk = body['signingKey']['privateJwk']
    new(long: , jwk: )
  end

  def resolve

  end

  private

  def resolve_did(did)
    services_json = {
      "services": [
        {
          "id": 'quattrowallet',
          "type": 'QuattroWallet',
          "serviceEndpoint": "https://issuer.quattro.example.com/wallets/#{current_user.wallet.id}"
        }
      ]
    }.to_json

    # DID Service へ DID の作成依頼を送る
    response = Net::HTTP.post(
      URI('http://localhost:3001/did/create'),
      services_json,
      'Content-Type' => 'application/json'
    )
    body = JSON.parse(response.body)

    # 返答を受け取る
    did_long_form = body['did']
    signing_key = body['singingKey']
    recovery_key = body['recoveryKey']
    update_key = body['updateKey']
  end

end
