class HoboMigration62 < ActiveRecord::Migration
  def self.up
    add_column :tareas, :ciclo, :integer

    add_column :procesos, :prueba, :boolean
    remove_column :procesos, :cambiar
    remove_column :procesos, :rehacer
  end

  def self.down
    remove_column :tareas, :ciclo

    remove_column :procesos, :prueba
    add_column :procesos, :cambiar, :boolean
    add_column :procesos, :rehacer, :boolean
  end
end
