class HoboMigration58 < ActiveRecord::Migration
  def self.up
    rename_column :tareas, :asignado_id, :asignada_a

    remove_index :tareas, :name => :index_tareas_on_asignado_id rescue ActiveRecord::StatementInvalid
    add_index :tareas, [:asignada_a]
  end

  def self.down
    rename_column :tareas, :asignada_a, :asignado_id

    remove_index :tareas, :name => :index_tareas_on_asignada_a rescue ActiveRecord::StatementInvalid
    add_index :tareas, [:asignado_id]
  end
end
