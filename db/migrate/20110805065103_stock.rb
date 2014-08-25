class Stock < ActiveRecord::Migration
  def self.up
    create_table :stocks do |t|
      t.integer  :cantidad
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :bodega_id
    end
    add_index :stocks, [:bodega_id]

    create_table :trozos do |t|
      t.string   :codigo
      t.decimal  :largo
      t.decimal  :ancho
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :polimero_id
      t.integer  :tarea_id
    end
    add_index :trozos, [:polimero_id]
    add_index :trozos, [:tarea_id]

    add_column :polimeros, :stock_id, :integer

    add_index :polimeros, [:stock_id]
  end

  def self.down
    remove_column :polimeros, :stock_id

    drop_table :stocks
    drop_table :trozos

    remove_index :polimeros, :name => :index_polimeros_on_stock_id rescue ActiveRecord::StatementInvalid
  end
end
