# frozen_string_literal: true

# 環境によって分けたい
ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "#{__dir__}/../../db/regtest.db"
)

unless ActiveRecord::Base.connection.table_exists?(:utxos)
  ActiveRecord::Migration.create_table :utxos, if_not_exists: true do |t|
    t.string :txid, index: true
    t.integer :vout
    t.string :token
    t.integer :value
    t.string :script_pubkey
    t.string :out_point, index: { unique: true }

    t.timestamps
  end
end

unless ActiveRecord::Base.connection.table_exists?(:infos)
  ActiveRecord::Migration.create_table :infos, if_not_exists: true do |t|
    t.string :key, index: { unique: true }
    t.string :value

    t.timestamps
  end
end
