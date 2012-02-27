class HoboMigration46 < ActiveRecord::Migration
  def self.up
    rename_column :polimeros, :marca, :tipomat
  end

  def self.down
    rename_column :polimeros, :tipomat, :marca
  end
end
