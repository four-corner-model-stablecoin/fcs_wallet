# frozen_string_literal: true

class Utxo < ActiveRecord::Base
  validates :out_point, uniqueness: true
end
