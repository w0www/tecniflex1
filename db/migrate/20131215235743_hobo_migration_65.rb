class HoboMigration65 < ActiveRecord::Migration
  def self.up
    drop_table :stocks

    remove_column :polimeros, :existencia_id

    change_column :users, :tablero, :boolean, :limit => 1, :default => false

    remove_column :movimientos, :observaciones
  end

  def self.down
    create_table "stocks", :force => true do |t|
      t.integer  "cantidad"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "bodega_id"
    end

    add_column :polimeros, :existencia_id, :integer

    change_column :users, :tablero, :boolean, :default => true

    add_column :movimientos, :observaciones, :text

    add_index "stocks", ["bodega_id"], :name => "index_stocks_on_bodega_id"
  end
end
