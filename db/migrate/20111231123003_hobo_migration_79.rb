class HoboMigration79 < ActiveRecord::Migration
  def self.up
    add_column :grupoprocs, :asignar, :boolean
  end

  def self.down
    remove_column :grupoprocs, :asignar
  end
end
