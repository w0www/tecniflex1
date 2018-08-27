class HoboMigration90 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :habilitar_ordenes, :boolean
  end

  def self.down
    remove_column :clientes, :habilitar_ordenes
  end
end
