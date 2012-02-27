class HoboMigration60 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :bodega_id, :integer
    add_column :movimientos, :user_id, :integer

    add_index :movimientos, [:bodega_id]
    add_index :movimientos, [:user_id]
  end

  def self.down
    remove_column :movimientos, :bodega_id
    remove_column :movimientos, :user_id

    remove_index :movimientos, :name => :index_movimientos_on_bodega_id rescue ActiveRecord::StatementInvalid
    remove_index :movimientos, :name => :index_movimientos_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
