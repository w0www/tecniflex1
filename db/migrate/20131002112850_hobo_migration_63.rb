class HoboMigration63 < ActiveRecord::Migration
  def self.up
    add_column :existencias, :unidad_id, :integer
    remove_index :existencias, :name => :index_stocks_on_bodega_id rescue ActiveRecord::StatementInvalid
    add_index :existencias, [:unidad_id]

    remove_column :movimientos, :separacion_id
    remove_index :movimientos, :name => :index_movimientos_on_separacion_id rescue ActiveRecord::StatementInvalid

    add_index :tareas, [:asignada_a]
  end

  def self.down
    remove_column :existencias, :unidad_id
    add_index :existencias, [:bodega_id], :name => 'index_stocks_on_bodega_id'

    add_column :movimientos, :separacion_id, :integer
    add_index :movimientos, [:separacion_id]

    remove_index :existencias, :name => :index_existencias_on_unidad_id rescue ActiveRecord::StatementInvalid
    remove_index :tareas, :name => :index_tareas_on_asignada_a rescue ActiveRecord::StatementInvalid
  end
end
