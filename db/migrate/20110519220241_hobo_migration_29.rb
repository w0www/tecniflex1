class HoboMigration29 < ActiveRecord::Migration
  def self.up
    remove_column :users, :area_mtz
    remove_column :users, :area_mtje
    remove_column :users, :area_film

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :users, :area_mtz, :boolean, :default => false
    add_column :users, :area_mtje, :boolean, :default => false
    add_column :users, :area_film, :boolean, :default => false

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
