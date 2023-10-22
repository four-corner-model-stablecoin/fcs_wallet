# frozen_string_literal: true

class Info < ActiveRecord::Base
  validates :key, uniqueness: true
end
