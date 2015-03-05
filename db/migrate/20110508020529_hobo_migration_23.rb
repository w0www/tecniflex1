class HoboMigration23 < ActiveRecord::Migration
  def self.up
    drop_table :productos

    rename_column :color_assignments, :producto_id, :ord_trab_id

    add_column :ord_trabs, :nomprod, :string
    add_column :ord_trabs, :codTflex, :string
    add_column :ord_trabs, :codCliente, :string
    add_column :ord_trabs, :mdi_desarrollo, :decimal
    add_column :ord_trabs, :mdi_ancho, :decimal
    add_column :ord_trabs, :barcode, :string
    add_column :ord_trabs, :colorBarcode, :string
    add_column :ord_trabs, :dispBandas, :integer
    add_column :ord_trabs, :distTotalPerim, :decimal
    add_column :ord_trabs, :distorAncho, :decimal
    add_column :ord_trabs, :nPasos, :decimal
    add_column :ord_trabs, :nBandas, :decimal
    add_column :ord_trabs, :colorUnion, :integer
    add_column :ord_trabs, :supRev, :integer
    add_column :ord_trabs, :caractImp, :text
    add_column :ord_trabs, :cliente_id, :integer
    add_column :ord_trabs, :impresora_id, :integer
    add_column :ord_trabs, :cilindro_id, :integer
    remove_column :ord_trabs, :producto_id

    rename_column :tintas, :producto_id, :ord_trab_id

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid
    add_index :color_assignments, [:ord_trab_id]

    remove_index :ord_trabs, :name => :index_ord_trabs_on_producto_id rescue ActiveRecord::StatementInvalid
    add_index :ord_trabs, [:cliente_id]
    add_index :ord_trabs, [:impresora_id]
    add_index :ord_trabs, [:cilindro_id]

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
    add_index :tintas, [:ord_trab_id]
  end

  def self.down
    rename_column :color_assignments, :ord_trab_id, :producto_id

    remove_column :ord_trabs, :nomprod
    remove_column :ord_trabs, :codTflex
    remove_column :ord_trabs, :codCliente
    remove_column :ord_trabs, :mdi_desarrollo
    remove_column :ord_trabs, :mdi_ancho
    remove_column :ord_trabs, :barcode
    remove_column :ord_trabs, :colorBarcode
    remove_column :ord_trabs, :dispBandas
    remove_column :ord_trabs, :distTotalPerim
    remove_column :ord_trabs, :distorAncho
    remove_column :ord_trabs, :nPasos
    remove_column :ord_trabs, :nBandas
    remove_column :ord_trabs, :colorUnion
    remove_column :ord_trabs, :supRev
    remove_column :ord_trabs, :caractImp
    remove_column :ord_trabs, :cliente_id
    remove_column :ord_trabs, :impresora_id
    remove_column :ord_trabs, :cilindro_id
    add_column :ord_trabs, :producto_id, :integer

    rename_column :tintas, :ord_trab_id, :producto_id

    create_table "productos", :force => true do |t|
      t.string   "name"
      t.string   "codTflex"
      t.string   "codCliente"
      t.decimal  "mdi_desarrollo"
      t.decimal  "mdi_ancho"
      t.string   "barcode"
      t.string   "colorBarcode"
      t.integer  "dispBandas"
      t.decimal  "distTotalPerim"
      t.decimal  "distorAncho"
      t.decimal  "nPasos"
      t.decimal  "nBandas"
      t.integer  "colorUnion"
      t.integer  "supRev"
      t.text     "caractImp"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "cliente_id"
      t.integer  "cilindro_id"
      t.integer  "impresora_id"
    end

    add_index "productos", ["cilindro_id"], :name => "index_productos_on_cilindro_id"
    add_index "productos", ["cliente_id"], :name => "index_productos_on_cliente_id"
    add_index "productos", ["impresora_id"], :name => "index_productos_on_impresora_id"

    remove_index :color_assignments, :name => :index_color_assignments_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    add_index :color_assignments, [:producto_id]

    remove_index :ord_trabs, :name => :index_ord_trabs_on_cliente_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_impresora_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_cilindro_id rescue ActiveRecord::StatementInvalid
    add_index :ord_trabs, [:producto_id]

    remove_index :tintas, :name => :index_tintas_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    add_index :tintas, [:producto_id]
  end
end
