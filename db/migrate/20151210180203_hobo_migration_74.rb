class HoboMigration74 < ActiveRecord::Migration
  def self.up
    remove_column :ord_trabs, :prioridad
  end

  def self.down
    add_column :ord_trabs, :prioridad, :string
  end
end
