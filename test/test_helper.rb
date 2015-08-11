$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler'
Bundler.require

require 'active_record'
require 'logger'
require 'mysql2'
require 'parallel'

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(adapter: 'mysql2')
ActiveRecord::Base.connection.execute('CREATE DATABASE IF NOT EXISTS dwek')
ActiveRecord::Base.connection.close

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: 'localhost',
  username: 'root',
  database: 'dwek',
  local_infile: true
)
$parent_pid = Process.pid

require 'dwek'
Dir[Pathname.new('test/fixtures').join('*.csv')].each do |filepath|
  Dwek::Form.new(filepath)
end
Dwek::SubjectTableFactory.build
Dwek::Subject.init_from((1..1000))

ActiveSupport.test_order = :random
require 'minitest/autorun'

Minitest.after_run do
  if Process.pid == $parent_pid
    ActiveRecord::Base.connection.execute('DROP DATABASE dwek')
  end
end
