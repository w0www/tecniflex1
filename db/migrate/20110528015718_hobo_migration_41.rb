class HoboMigration41 < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :state, :string, :default => "detenida"
    add_column :intervencions, :key_timestamp, :datetime

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    add_index :intervencions, [:state]

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :intervencions, :state
    remove_column :intervencions, :key_timestamp

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    remove_index :intervencions, :name => :index_intervencions_on_state rescue ActiveRecord::StatementInvalid

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
