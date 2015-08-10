$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler'
Bundler.require

require 'active_record'
require 'logger'
require 'mysql2'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: 'localhost',
  username: 'root',
  database: 'dwek',
  local_infile: true
)

require 'dwek'
Dir[Pathname.new('test/fixtures').join('{dem,enrol}.csv')].each do |filepath|
  Dwek::Form.new(filepath)
end
Dwek::SubjectTableFactory.build
Dwek::Subject.init_from(Dwek::TempTable::Enrol.distinct.limit(100).pluck(:subject))

ActiveSupport.test_order = :random
require 'minitest/autorun'
