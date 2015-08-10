$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_record'
require 'minitest/autorun'
require 'dwek'
require 'support/fixtures'

ActiveSupport.test_order = :sorted
