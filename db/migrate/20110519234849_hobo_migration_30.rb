class HoboMigration30 < ActiveRecord::Migration
  def self.up
    create_table :procesos_users, :id => false do |t|
      t.integer :proceso_id
      t.integer :user_id
    end

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    drop_table :procesos_users

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
