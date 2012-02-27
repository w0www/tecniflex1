class HoboMigration28 < ActiveRecord::Migration
  def self.up
    rename_column :ord_trabs, :film, :ptr

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    rename_column :ord_trabs, :ptr, :film

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
