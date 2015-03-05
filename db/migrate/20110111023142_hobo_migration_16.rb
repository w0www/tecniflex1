class HoboMigration16 < ActiveRecord::Migration
  def self.up
    add_column :users, :area_mtz, :boolean, :default => false
    add_column :users, :area_mtje, :boolean, :default => false
    add_column :users, :area_film, :boolean, :default => false
  end

  def self.down
    remove_column :users, :area_mtz
    remove_column :users, :area_mtje
    remove_column :users, :area_film
  end
end
