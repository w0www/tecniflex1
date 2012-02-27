class HoboMigration52 < ActiveRecord::Migration
  def self.up
    remove_column :aniloxes, :nombre

    remove_column :cilindros, :anilox
    remove_column :cilindros, :lineatura

    rename_column :existencias, :alto, :existalto
    rename_column :existencias, :ancho, :existancho
  end

  def self.down
    add_column :aniloxes, :nombre, :string

    add_column :cilindros, :anilox, :string
    add_column :cilindros, :lineatura, :string

    rename_column :existencias, :existalto, :alto
    rename_column :existencias, :existancho, :ancho
  end
end
