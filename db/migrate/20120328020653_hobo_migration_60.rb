class HoboMigration60 < ActiveRecord::Migration
  def self.up
    add_column :procesos, :cambiar, :boolean
    add_column :procesos, :rehacer, :boolean
  end

  def self.down
    remove_column :procesos, :cambiar
    remove_column :procesos, :rehacer
  end
end
