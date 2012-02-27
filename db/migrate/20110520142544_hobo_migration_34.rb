class HoboMigration34 < ActiveRecord::Migration
  def self.up
    drop_table :procesos_users

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    create_table "procesos_users", :id => false, :force => true do |t|
      t.integer "proceso_id"
      t.integer "user_id"
    end

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
