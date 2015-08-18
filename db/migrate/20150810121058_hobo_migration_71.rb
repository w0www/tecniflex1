class HoboMigration71 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :password, :string
  end

  def self.down
    remove_column :clientes, :password
  end
end
