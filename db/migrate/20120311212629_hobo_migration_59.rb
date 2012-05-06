class HoboMigration59 < ActiveRecord::Migration
  def self.up
    add_column :grupoprocs, :saevb, :boolean
    add_column :grupoprocs, :saemtz, :boolean
    add_column :grupoprocs, :saemtje, :boolean
    add_column :grupoprocs, :saeptr, :boolean
  end

  def self.down
    remove_column :grupoprocs, :saevb
    remove_column :grupoprocs, :saemtz
    remove_column :grupoprocs, :saemtje
    remove_column :grupoprocs, :saeptr
  end
end
