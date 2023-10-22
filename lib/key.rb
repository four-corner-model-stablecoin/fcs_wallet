# frozen_string_literal: true

class Key
  # @params hash jwk_hash
  def self.generate_from_jwk(jwk_hash = nil)
    jwk = JSON::JWK.new(jwk_hash || load_from_json_file)
    Tapyrus::Key.new(priv_key: jwk.to_key.private_key.to_s(16).downcase.encode('US-ASCII'), key_type: 0)
  end

  private

  def self.load_from_json_file
    File.open("#{__dir__}/../config/credentials/jwk.json") { |f| JSON.load(f) }
  end
end
