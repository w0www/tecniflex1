class HoboMigration75 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :generar_xml, :boolean
  end

  def self.down
    remove_column :clientes, :generar_xml
  end
end
