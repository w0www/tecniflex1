class HoboMigration38 < ActiveRecord::Migration
  def self.up
    create_table :polimeros do |t|
      t.string   :marca
      t.string   :tipo
      t.decimal  :espesor
      t.string   :nombre
      t.integer  :alto
      t.integer  :ancho
      t.datetime :created_at
      t.datetime :updated_at
    end

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    drop_table :polimeros

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
