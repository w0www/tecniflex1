class HoboMigration58 < ActiveRecord::Migration
  def self.up
    add_column :curvas, :lineatura, :string
    add_column :curvas, :impresora_id, :integer

    add_column :existencias, :unidad_id, :integer

    remove_column :movimientos, :observaciones

    add_index :curvas, [:impresora_id]

    add_index :existencias, [:unidad_id]
  end

  def self.down
    remove_column :curvas, :lineatura
    remove_column :curvas, :impresora_id

    remove_column :existencias, :unidad_id

    add_column :movimientos, :observaciones, :text

    remove_index :curvas, :name => :index_curvas_on_impresora_id rescue ActiveRecord::StatementInvalid

    remove_index :existencias, :name => :index_existencias_on_unidad_id rescue ActiveRecord::StatementInvalid
  end
end
