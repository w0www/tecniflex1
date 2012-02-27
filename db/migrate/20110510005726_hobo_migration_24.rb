class HoboMigration24 < ActiveRecord::Migration
  def self.up
    rename_column :ord_trabs, :caractImp, :sustrato
    change_column :ord_trabs, :sustrato, :string, :limit => 255

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    rename_column :ord_trabs, :sustrato, :caractImp
    change_column :ord_trabs, :caractImp, :text

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
