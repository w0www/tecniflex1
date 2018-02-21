class HoboMigration86 < ActiveRecord::Migration
  def self.up
    add_column :users, :panel_supervisor, :boolean, :default => false
  end

  def self.down
    remove_column :users, :panel_supervisor
  end
end
