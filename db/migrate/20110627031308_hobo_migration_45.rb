class HoboMigration45 < ActiveRecord::Migration
  def self.up
    add_column :separacions, :area, :decimal
    add_column :separacions, :alto, :decimal
    add_column :separacions, :ancho, :decimal
  end

  def self.down
    remove_column :separacions, :area
    remove_column :separacions, :alto
    remove_column :separacions, :ancho
  end
end
