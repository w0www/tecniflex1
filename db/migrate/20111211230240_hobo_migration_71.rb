class HoboMigration71 < ActiveRecord::Migration
  def self.up
    add_column :procesos, :position, :integer
  end

  def self.down
    remove_column :procesos, :position
  end
end
