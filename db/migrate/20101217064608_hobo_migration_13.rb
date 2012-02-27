class HoboMigration13 < ActiveRecord::Migration
  def self.up
    add_column :productos, :cliente_id, :integer

    add_index :productos, [:cliente_id]
  end

  def self.down
    remove_column :productos, :cliente_id

    remove_index :productos, :name => :index_productos_on_cliente_id rescue ActiveRecord::StatementInvalid
  end
end
