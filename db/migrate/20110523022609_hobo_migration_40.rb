class HoboMigration40 < ActiveRecord::Migration
  def self.up
    add_column :procesos, :sucesor_id, :integer

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    add_index :procesos, [:sucesor_id]

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :procesos, :sucesor_id

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    remove_index :procesos, :name => :index_procesos_on_sucesor_id rescue ActiveRecord::StatementInvalid

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
