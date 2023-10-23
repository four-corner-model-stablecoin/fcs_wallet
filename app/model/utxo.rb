# frozen_string_literal: true

module FCSWallet
  class UTXO < ActiveRecord::Base
    validates :out_point, uniqueness: true
  end
end
