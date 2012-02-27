class HoboMigration39 < ActiveRecord::Migration
  def self.up
    remove_column :ord_trabs, :state
    remove_column :ord_trabs, :key_timestamp

    add_column :tareas, :state, :string, :default => "creada"
    add_column :tareas, :key_timestamp, :datetime

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :ord_trabs, :name => :index_ord_trabs_on_state rescue ActiveRecord::StatementInvalid

    add_index :tareas, [:state]

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :ord_trabs, :state, :string, :default => "definida"
    add_column :ord_trabs, :key_timestamp, :datetime

    remove_column :tareas, :state
    remove_column :tareas, :key_timestamp

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :ord_trabs, [:state]

    remove_index :tareas, :name => :index_tareas_on_state rescue ActiveRecord::StatementInvalid

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
