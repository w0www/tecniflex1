class HoboMigration65 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :lote, :string
    add_column :movimientos, :serie, :string
    remove_column :movimientos, :fecha
    remove_column :movimientos, :polimero_id
    remove_column :movimientos, :observaciones

    remove_index :movimientos, :name => :index_movimientos_on_polimero_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :movimientos, :lote
    remove_column :movimientos, :serie
    add_column :movimientos, :fecha, :date
    add_column :movimientos, :polimero_id, :integer
    add_column :movimientos, :observaciones, :text

    add_index :movimientos, [:polimero_id]
  end
end
