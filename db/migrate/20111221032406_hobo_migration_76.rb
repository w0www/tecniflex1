class HoboMigration76 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :correo, :string
  end

  def self.down
    remove_column :clientes, :correo
  end
end
