class HoboMigration78 < ActiveRecord::Migration
  def self.up
    add_column :separacions, :nCopias, :integer
  end

  def self.down
    remove_column :separacions, :nCopias
  end
end
