class HoboMigration80 < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :final, :boolean
  end

  def self.down
    remove_column :intervencions, :final
  end
end
