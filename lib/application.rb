# frozen_string_literal: true

require 'active_record'
require 'json/jwt'
require 'logger'
require 'sqlite3'

require 'tapyrus'
include Tapyrus::Opcodes
require 'dotenv'
Dotenv.load "#{__dir__}/../.env"

require_relative './initializer/active_record'
require_relative './initializer/tapyrus'
require_relative './key'
