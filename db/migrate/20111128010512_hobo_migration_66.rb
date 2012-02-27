class HoboMigration66 < ActiveRecord::Migration
  def self.up
    add_column :existencias, :serie, :string
    remove_column :existencias, :tipo
    remove_column :existencias, :unidades

    add_column :movimientos, :polimero_id, :integer

    add_index :movimientos, [:polimero_id]
  end

  def self.down
    remove_column :existencias, :serie
    add_column :existencias, :tipo, :string
    add_column :existencias, :unidades, :integer

    remove_column :movimientos, :polimero_id

    remove_index :movimientos, :name => :index_movimientos_on_polimero_id rescue ActiveRecord::StatementInvalid
  end
end
