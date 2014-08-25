class HoboMigration8 < ActiveRecord::Migration
  def self.up
    rename_column :cilindros, :diametro, :name
  end

  def self.down
    rename_column :cilindros, :name, :diametro
  end
end
