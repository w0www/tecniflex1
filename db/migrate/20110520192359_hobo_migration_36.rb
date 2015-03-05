class HoboMigration36 < ActiveRecord::Migration
  def self.up
    add_column :user_labors, :user_id, :integer
    add_column :user_labors, :proceso_id, :integer

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid

    add_index :user_labors, [:user_id]
    add_index :user_labors, [:proceso_id]
  end

  def self.down
    remove_column :user_labors, :user_id
    remove_column :user_labors, :proceso_id

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'

    remove_index :user_labors, :name => :index_user_labors_on_user_id rescue ActiveRecord::StatementInvalid
    remove_index :user_labors, :name => :index_user_labors_on_proceso_id rescue ActiveRecord::StatementInvalid
  end
end
