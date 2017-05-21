class HoboMigration84 < ActiveRecord::Migration
  def self.up
    add_column :users, :gerencial, :boolean, :default => false
  end

  def self.down
    remove_column :users, :gerencial
   end
end
