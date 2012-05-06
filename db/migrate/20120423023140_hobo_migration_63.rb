class HoboMigration63 < ActiveRecord::Migration
  def self.up
    add_column :tareas, :ciclovb, :integer
    add_column :tareas, :cicloptr, :integer
    remove_column :tareas, :ciclo

    add_column :procesos, :reinit, :boolean
  end

  def self.down
    remove_column :tareas, :ciclovb
    remove_column :tareas, :cicloptr
    add_column :tareas, :ciclo, :integer

    remove_column :procesos, :reinit
  end
end
