# frozen_string_literal: true

class UTXO < ActiveRecord::Base
  validates :out_point, uniqueness: true
end
