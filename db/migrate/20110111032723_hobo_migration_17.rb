class HoboMigration17 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :mtz, :boolean
    add_column :ord_trabs, :mtje, :boolean
    add_column :ord_trabs, :film, :boolean
  end

  def self.down
    remove_column :ord_trabs, :mtz
    remove_column :ord_trabs, :mtje
    remove_column :ord_trabs, :film
  end
end
