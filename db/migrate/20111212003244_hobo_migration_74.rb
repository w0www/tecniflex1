class HoboMigration74 < ActiveRecord::Migration
  def self.up
    add_column :grupoprocs, :abreviacion, :string
  end

  def self.down
    remove_column :grupoprocs, :abreviacion
  end
end
