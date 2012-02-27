class HoboMigration70 < ActiveRecord::Migration
  def self.up
    remove_column :ord_trabs, :curva
  end

  def self.down
    add_column :ord_trabs, :curva, :string
  end
end
