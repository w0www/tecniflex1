class HoboMigration52 < ActiveRecord::Migration
  def self.up
    rename_column :existencias, :alto, :existalto
    rename_column :existencias, :ancho, :existancho
  end

  def self.down
    rename_column :existencias, :existalto, :alto
    rename_column :existencias, :existancho, :ancho
  end
end
