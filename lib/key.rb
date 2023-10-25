# frozen_string_literal: true

module FCSWallet
  class Key
    # @params hash jwk_hash
    def self.from_jwk(jwk_hash = nil)
      jwk = JSON::JWK.new(jwk_hash || load_from_json_file)
      key = jwk.to_key
      if key.private_key.nil?
        Tapyrus::Key.new(pubkey: key.public_key.to_bn.to_s(16).downcase.encode('US-ASCII'), key_type: 0)
      else
        Tapyrus::Key.new(priv_key: key.private_key.to_s(16).downcase.encode('US-ASCII'), key_type: 0)
      end
    end

    private

    def self.load_from_json_file
      File.open("#{__dir__}/../config/credentials/jwk.json") { |f| JSON.load(f) }
    end
  end
end
