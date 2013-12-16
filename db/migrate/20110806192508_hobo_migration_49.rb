class HoboMigration49 < ActiveRecord::Migration
  def self.up
    drop_table :trozos

    add_column :movimientos, :separacion_id, :integer

    add_index :movimientos, [:separacion_id]
  end

  def self.down
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

    remove_index :movimientos, :name => :index_movimientos_on_separacion_id rescue ActiveRecord::StatementInvalid
  end
end
