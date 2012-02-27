class HoboMigration54 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :cfinal, :string
  end

  def self.down
    remove_column :ord_trabs, :cfinal
  end
end
