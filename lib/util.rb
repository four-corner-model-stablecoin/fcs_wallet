# frozen_string_literal: true

module FCSWallet
  module Util
    # @return pid|nil
    def self.wallet_running?
      pid = File.open("#{__dir__}/../tmp/walletd.pid", 'r') { |f| f.read }
      return pid if Process.kill(0, pid.to_i)
    rescue
      nil
    end
  end
end
