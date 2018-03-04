class HoboMigration87 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :nBandas2, :decimal, :scale => 2, :default => 0, :precision => 8
  end

  def self.down
    remove_column :ord_trabs, :nBandas2
  end
end
