class HoboMigration78 < ActiveRecord::Migration
  def self.up
    add_column :grupoprocs, :tablero, :boolean
  end

  def self.down
    remove_column :grupoprocs, :tablero
  end
end
