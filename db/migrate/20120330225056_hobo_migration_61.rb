class HoboMigration61 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :version, :integer
  end

  def self.down
    remove_column :ord_trabs, :version
  end
end
