class HoboMigration70 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :cuenta_usuario, :boolean, :default => false
  end

  def self.down
    remove_column :clientes, :cuenta_usuario
  end
end
