class HoboMigration57 < ActiveRecord::Migration
  def self.up
    add_column :procesos, :grupo, :string
  end

  def self.down
    remove_column :procesos, :grupo
  end
end
