class HoboMigration79 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :fechafin, :date

    add_column :tareas, :fechafin, :date
  end

  def self.down
    remove_column :ord_trabs, :fechafin

    remove_column :tareas, :fechafin
  end
end
