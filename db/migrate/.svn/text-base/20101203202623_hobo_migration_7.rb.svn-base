class HoboMigration7 < ActiveRecord::Migration
  def self.up
    add_column :cilindros, :impresora_id, :integer

    add_column :impresoras, :cliente_id, :integer

    add_column :ord_trabs, :producto_id, :integer

    add_index :cilindros, [:impresora_id]

    add_index :impresoras, [:cliente_id]

    add_index :ord_trabs, [:producto_id]
  end

  def self.down
    remove_column :cilindros, :impresora_id

    remove_column :impresoras, :cliente_id

    remove_column :ord_trabs, :producto_id

    remove_index :cilindros, :name => :index_cilindros_on_impresora_id rescue ActiveRecord::StatementInvalid

    remove_index :impresoras, :name => :index_impresoras_on_cliente_id rescue ActiveRecord::StatementInvalid

    remove_index :ord_trabs, :name => :index_ord_trabs_on_producto_id rescue ActiveRecord::StatementInvalid
  end
end
