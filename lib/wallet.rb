# frozen_string_literal: true

require 'sqlite3'
require 'active_record'
require 'tapyrus'
require 'json/jwt'
require 'debug'
require 'dotenv'

include Tapyrus::Opcodes

Dotenv.load

Tapyrus.chain_params = :dev if ENV['TAPYRUS_CHAIN_PARAMS'] == 'dev'
TAPYRUS_RPC_CLIENT = Tapyrus::RPC::TapyrusCoreClient.new({
  schema: ENV['TAPYRUS_RPC_SCHEMA'],
  host: ENV['TAPYRUS_RPC_HOST'],
  port: ENV['TAPYRUS_RPC_PORT'],
  user: ENV['TAPYRUS_RPC_USER'],
  password: ENV['TAPYRUS_RPC_PASSWORD']
})

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  'db/production.db'
)

ActiveRecord::Migration.create_table :utxos, if_not_exists: true do |t|
  t.string :txid, index: true
  t.integer :vout
  t.string :token
  t.integer :value
  t.string :script_pubkey
  t.string :out_point, index: { unique: true }

  t.timestamps
end

ActiveRecord::Migration.create_table :infos, if_not_exists: true do |t|
  t.string :key, index: { unique: true }
  t.string :value

  t.timestamps
end

class Utxo < ActiveRecord::Base
  validates :out_point, uniqueness: true
end

class Info < ActiveRecord::Base
  validates :key, uniqueness: true
end

key = nil
File.open("credentials/jwk.json") do |f|
  jwk_hash = JSON.load(f)
  jwk = JSON::JWK.new(jwk_hash)
  key = Tapyrus::Key.new(priv_key: jwk.to_key.private_key.to_s(16).downcase.encode('US-ASCII'), key_type: 0)
end

# utxos の hash
# example:
# [
#   {
#     txid: hoge,
#     vout: 0,
#     token: color_id || TPC
#     value: 50,
#     script_pubkey: script_pubkey.to_payload.bth,
#     out_point: outpoint.to_payload.bth
#   }
# ]
utxos = []
utxos.concat Utxo.all.map(&:attributes)

current_block_header = Info.find_or_create_by(key: 'current_block_header')
current_block_count = current_block_header.value.to_i || 0

loop do
  puts ""
  puts "Getting block count..."
  block_count = TAPYRUS_RPC_CLIENT.getblockcount

  while current_block_count < block_count do
    current_block_count += 1
    current_block_header.update!(value: current_block_count)

    puts "Getting block info..."
    block_hash = TAPYRUS_RPC_CLIENT.getblockhash(current_block_count)
    block = TAPYRUS_RPC_CLIENT.getblock(block_hash)
    puts "  Block: #{block_hash}"

    block['tx'].each do |txid|
      puts "    Transaction: #{txid}"
      tx = Tapyrus::Tx.parse_from_payload(TAPYRUS_RPC_CLIENT.getrawtransaction(txid).htb)

      # input に utxos の中身が使われていれば削除
      tx.inputs.each do |input|
        utxos.delete(utxos.find { _1[:out_point] == input.out_point.to_payload.bth })
      end

      # key.pubkey が含まれる scriptPubKey を持つ UTXO を検索
      tx.outputs.each_with_index do |output, vout|
        # これだと P2SH は拾えないのでは？
        script_pubkey = output.script_pubkey
        if script_pubkey.to_s.include?(key.pubkey)
          color_id = script_pubkey.to_s.split(" ").first if script_pubkey.to_s.split(" ").second == "OP_COLOR"
          utxos << {
            txid:,
            vout:,
            token: color_id || 'TPC',
            value: output.value,
            script_pubkey: script_pubkey.to_payload.bth,
            out_point: Tapyrus::OutPoint.from_txid(txid, vout).to_payload.bth
          }
        end
      end
    end
  end

  puts "Current UTXOs: "
  pp utxos

  utxos.each do |utxo|
    Utxo.create(utxo).save
  end

  puts "Waiting next sync... (30 seconds after)"
  sleep 30.seconds
end
