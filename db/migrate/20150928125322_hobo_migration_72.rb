class HoboMigration72 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :color, :string
  end

  def self.down
    remove_column :ord_trabs, :color
  end
end
