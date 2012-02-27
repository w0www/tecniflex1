class HoboMigration49 < ActiveRecord::Migration
  def self.up
    drop_table :trozos

    add_column :existencias, :tipo, :string
    add_column :existencias, :unidades, :integer
    add_column :existencias, :alto, :decimal
    add_column :existencias, :ancho, :decimal
    add_column :existencias, :polimero_id, :integer

    add_column :movimientos, :separacion_id, :integer

    add_index :existencias, [:polimero_id]

    add_index :movimientos, [:separacion_id]
  end

  def self.down
    remove_column :existencias, :tipo
    remove_column :existencias, :unidades
    remove_column :existencias, :alto
    remove_column :existencias, :ancho
    remove_column :existencias, :polimero_id

    remove_column :movimientos, :separacion_id

    create_table "trozos", :force => true do |t|
      t.string   "codigo"
      t.decimal  "largo"
      t.decimal  "ancho"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "polimero_id"
      t.integer  "tarea_id"
    end

    add_index "trozos", ["polimero_id"], :name => "index_trozos_on_polimero_id"
    add_index "trozos", ["tarea_id"], :name => "index_trozos_on_tarea_id"

    remove_index :existencias, :name => :index_existencias_on_polimero_id rescue ActiveRecord::StatementInvalid

    remove_index :movimientos, :name => :index_movimientos_on_separacion_id rescue ActiveRecord::StatementInvalid
  end
end
