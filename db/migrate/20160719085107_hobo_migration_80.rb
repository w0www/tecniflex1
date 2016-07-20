class HoboMigration80 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :pantalla_gerencial, :boolean
  end

  def self.down
    remove_column :clientes, :pantalla_gerencial
  end
end
