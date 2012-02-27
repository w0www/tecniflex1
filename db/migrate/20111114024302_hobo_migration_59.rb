class HoboMigration59 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :prioridad, :string
  end

  def self.down
    remove_column :ord_trabs, :prioridad
  end
end
