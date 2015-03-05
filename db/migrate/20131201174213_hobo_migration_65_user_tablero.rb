class HoboMigration65UserTablero < ActiveRecord::Migration
  def self.up
    add_column :users, :tablero, :boolean, :default => true
  end

  def self.down
    remove_column :users, :tablero
  end
end
