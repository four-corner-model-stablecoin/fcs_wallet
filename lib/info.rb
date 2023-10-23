# frozen_string_literal: true

module FCSWallet
  class Info < ActiveRecord::Base
    validates :key, uniqueness: true
  end
end
