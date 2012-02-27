class HoboMigration62 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :observaciones, :text
    add_column :movimientos, :ord_trab_id, :integer
    remove_column :movimientos, :separacion_id

    remove_index :movimientos, :name => :index_movimientos_on_separacion_id rescue ActiveRecord::StatementInvalid
    add_index :movimientos, [:ord_trab_id]
  end

  def self.down
    remove_column :movimientos, :observaciones
    remove_column :movimientos, :ord_trab_id
    add_column :movimientos, :separacion_id, :integer

    remove_index :movimientos, :name => :index_movimientos_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    add_index :movimientos, [:separacion_id]
  end
end
