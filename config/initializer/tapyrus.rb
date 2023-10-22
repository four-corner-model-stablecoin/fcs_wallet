# frozen_string_literal: true

Tapyrus.chain_params = :dev if ENV['TAPYRUS_CHAIN_PARAMS'] == 'dev'
TAPYRUS_RPC_CLIENT = Tapyrus::RPC::TapyrusCoreClient.new({
  schema: ENV['TAPYRUS_RPC_SCHEMA'],
  host: ENV['TAPYRUS_RPC_HOST'],
  port: ENV['TAPYRUS_RPC_PORT'],
  user: ENV['TAPYRUS_RPC_USER'],
  password: ENV['TAPYRUS_RPC_PASSWORD']
})
