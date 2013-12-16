class HoboMigration63 < ActiveRecord::Migration
  def self.up
    add_column :existencias, :unidad_id, :integer
    remove_column :existencias, :tipo
    remove_column :existencias, :unidades
    remove_index :existencias, :name => :index_stocks_on_bodega_id rescue ActiveRecord::StatementInvalid
    add_index :existencias, [:unidad_id]

    remove_column :movimientos, :separacion_id
    remove_index :movimientos, :name => :index_movimientos_on_separacion_id rescue ActiveRecord::StatementInvalid

    add_index :tareas, [:asignada_a]

    add_index :polimeros, [:tipomat_id]
    add_index :polimeros, [:espesor_id]
  end

  def self.down
    remove_column :existencias, :unidad_id
    add_column :existencias, :tipo, :string
    add_column :existencias, :unidades, :integer
    add_index :existencias, [:bodega_id], :name => 'index_stocks_on_bodega_id'
    remove_index :existencias, :name => :index_existencias_on_unidad_id rescue ActiveRecord::StatementInvalid

    add_column :movimientos, :separacion_id, :integer
    add_index :movimientos, [:separacion_id]

    remove_index :tareas, :name => :index_tareas_on_asignada_a rescue ActiveRecord::StatementInvalid

    remove_index :polimeros, :name => :index_polimeros_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :polimeros, :name => :index_polimeros_on_espesor_id rescue ActiveRecord::StatementInvalid
  end
end
