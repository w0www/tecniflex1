class HoboMigration64 < ActiveRecord::Migration
  def self.up
    add_column :mov_headers, :proveedor, :string
  end

  def self.down
    remove_column :mov_headers, :proveedor
  end
end
