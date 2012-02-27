class HoboMigration63 < ActiveRecord::Migration
  def self.up

    create_table :mov_headers do |t|
      t.integer  :factura
      t.date     :fecha
      t.text     :observaciones
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :movimientos, :mov_header_id, :integer
    remove_column :movimientos, :factura

    add_index :movimientos, [:mov_header_id]
  end

  def self.down
    remove_column :movimientos, :mov_header_id
    add_column :movimientos, :factura, :integer

    
    drop_table :mov_headers

    remove_index :movimientos, :name => :index_movimientos_on_mov_header_id rescue ActiveRecord::StatementInvalid
  end
end
