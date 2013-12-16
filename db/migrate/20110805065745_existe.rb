class Existe < ActiveRecord::Migration
  def self.up
    rename_column :polimeros, :stock_id, :existencia_id

    remove_index :existencias, :name => :index_stocks_on_bodega_id rescue ActiveRecord::StatementInvalid
    add_index :existencias, [:bodega_id]

    remove_index :polimeros, :name => :index_polimeros_on_stock_id rescue ActiveRecord::StatementInvalid
    add_index :polimeros, [:existencia_id]
  end

  def self.down
    rename_column :polimeros, :existencia_id, :stock_id

    remove_index :stocks, :name => :index_existencias_on_bodega_id rescue ActiveRecord::StatementInvalid
    add_index :stocks, [:bodega_id]

    remove_index :polimeros, :name => :index_polimeros_on_existencia_id rescue ActiveRecord::StatementInvalid
    add_index :polimeros, [:stock_id]
  end
end
