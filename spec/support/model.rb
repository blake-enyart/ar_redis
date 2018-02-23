require "active_record"

AR_VERSION = Gem::Version.new(ActiveRecord::VERSION::STRING)
AR_4_0 = Gem::Version.new("4.0")

class CreateAllTables < ActiveRecord::Migration[5.0]
  def self.recreate_table(name, *args, &block)
    execute "drop table if exists #{name}"

    create_table(name, *args) do |t|
      t.string :name
    end
  end

  def self.up
    ActiveRecord::Base.establish_connection({ adapter: "sqlite3", database: "/tmp/ar_redis.db" })
    recreate_table(:test_models)
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up

class TestModel < ActiveRecord::Base
end

RSpec.configure do |config|
  config.before(:each) do
    TestModel.delete_all
    TestModel.redis.delete_all
  end
end