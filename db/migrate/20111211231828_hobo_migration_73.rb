class HoboMigration73 < ActiveRecord::Migration
  def self.up
    remove_column :procesos, :grupo
  end

  def self.down
    add_column :procesos, :grupo, :string
  end
end
