adapter = RUBY_PLATFORM == 'java' ? 'jdbc/mysql' : 'mysql2'
require adapter

require 'active_record'
require "action_service/orm/guard"

logger = Logger.new File.expand_path( "../support/log/test.log", __FILE__)
logger.formatter = proc { |severity, datetime, progname, msg|
  "[#{severity}] #{msg}\n"
}

ActiveRecord::Base.logger = logger
ActiveRecord::Base.establish_connection(
  :adapter   => adapter.gsub('/', ''),
  :database  => 'action_service_test',
  :username  => 'root',
  :encoding  => 'utf8'
)
