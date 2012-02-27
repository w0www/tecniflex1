class HoboMigration75 < ActiveRecord::Migration
  def self.up
    add_column :grupoprocs, :position, :integer
  end

  def self.down
    remove_column :grupoprocs, :position
  end
end
