class HoboMigration50 < ActiveRecord::Migration
  def self.up
    add_column :existencias, :codigo, :string
  end

  def self.down
    remove_column :existencias, :codigo
  end
end
