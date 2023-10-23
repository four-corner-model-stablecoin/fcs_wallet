# frozen_string_literal: true

require_relative '../../app/model/utxo'
require_relative '../../app/model/info'

# 環境によって分けたい
ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "#{__dir__}/../../db/regtest.db"
)