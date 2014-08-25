class HoboMigration19 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :visto, :boolean
  end

  def self.down
    remove_column :ord_trabs, :visto
  end
end
