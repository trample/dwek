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
Dir[Pathname.new('test/fixtures').join('*.csv')].each do |filepath|
  Dwek::Form.new(filepath)
end
Dwek::SubjectTableFactory.build
Dwek::Subject.init_from((1..1000))

ActiveSupport.test_order = :random
require 'minitest/autorun'

# Dwek::Subject.init_from((1..10))
# Dwek::ParallelMapping.new(Dwek::Mappers::DirectMapper.new(:first_name, form: 'person', field: 'first_name'))
