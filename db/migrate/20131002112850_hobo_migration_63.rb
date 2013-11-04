class HoboMigration63 < ActiveRecord::Migration
  def self.up
    create_table :grupoprocs do |t|
      t.integer  :position
      t.string   :nombre
      t.string   :abreviacion
      t.boolean  :tablero
      t.boolean  :asignar
      t.boolean  :saevb
      t.boolean  :saemtz
      t.boolean  :saemtje
      t.boolean  :saeptr
      t.boolean  :saepol
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :sustratos do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :unidads do |t|
      t.string   :nombre
      t.text     :descripcion
      t.integer  :cantunimenor
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :unimenor_id
    end
    add_index :unidads, [:unimenor_id]

    create_table :mov_headers do |t|
      t.integer  :factura
      t.date     :fecha
      t.string   :proveedor
      t.text     :observaciones
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :espesors do |t|
      t.decimal  :calibre, :scale => 2, :precision => 3
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :tipomats do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :curva_clientes do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :curva_id
      t.integer  :cliente_id
    end
    add_index :curva_clientes, [:curva_id]
    add_index :curva_clientes, [:cliente_id]

    create_table :curvas do |t|
      t.string   :nombre
      t.text     :descripcion
      t.string   :impresion
      t.string   :lineatura
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :tipomat_id
      t.integer  :espesor_id
      t.integer  :sustrato_id
      t.integer  :impresora_id
    end
    add_index :curvas, [:tipomat_id]
    add_index :curvas, [:espesor_id]
    add_index :curvas, [:sustrato_id]
    add_index :curvas, [:impresora_id]

    add_column :separacions, :tipomat_id, :integer
    add_column :separacions, :espesor_id, :integer
    remove_column :separacions, :tipomat
    remove_column :separacions, :grosor
    change_column :separacions, :ancho, :decimal, :limit => nil
    change_column :separacions, :area, :decimal, :limit => nil
    change_column :separacions, :alto, :decimal, :limit => nil

    add_column :existencias, :serie, :string
    add_column :existencias, :unidad_id, :integer
    remove_column :existencias, :tipo
    remove_column :existencias, :unidades
    change_column :existencias, :existancho, :decimal, :limit => nil
    change_column :existencias, :existalto, :decimal, :limit => nil

    add_column :movimientos, :lote, :string
    add_column :movimientos, :serie, :string
    add_column :movimientos, :mov_header_id, :integer
    add_column :movimientos, :bodega_id, :integer
    add_column :movimientos, :ord_trab_id, :integer
    add_column :movimientos, :user_id, :integer
    remove_column :movimientos, :factura
    remove_column :movimientos, :separacion_id
    remove_column :movimientos, :fecha

    add_column :impresoras, :curva_id, :integer
    change_column :impresoras, :trapdefault, :decimal, :limit => nil

    change_column :aniloxes, :bcm, :decimal, :scale => 2, :precision => 5, :limit => nil

    add_column :procesos, :position, :integer
    add_column :procesos, :prueba, :boolean
    add_column :procesos, :reinit, :boolean
    add_column :procesos, :varev, :boolean
    add_column :procesos, :rev, :boolean
    add_column :procesos, :destderev, :boolean
    add_column :procesos, :edmeds, :boolean
    add_column :procesos, :factura, :boolean, :default => false
    add_column :procesos, :grupoproc_id, :integer
    remove_column :procesos, :grupo

    add_column :tareas, :ciclo, :integer
    add_column :tareas, :asignada_a, :integer
    remove_column :tareas, :asignado_id
    remove_column :tareas, :position

    add_column :cilindros, :nombre, :string
    remove_column :cilindros, :name
    change_column :cilindros, :distorsion, :decimal, :limit => nil
    change_column :cilindros, :pctDistor, :decimal, :scale => 3, :precision => 5, :limit => nil
    change_column :cilindros, :espesor, :decimal, :scale => 2, :precision => 3, :limit => nil

    add_column :polimeros, :tipomat_id, :integer
    add_column :polimeros, :espesor_id, :integer
    remove_column :polimeros, :tipomat
    remove_column :polimeros, :espesor

    add_column :intervencions, :final, :boolean

    add_column :clientes, :sigla, :string
    add_column :clientes, :correo, :string
    change_column :clientes, :tarifa, :decimal, :limit => nil

    add_column :ord_trabs, :vb, :boolean
    add_column :ord_trabs, :pol, :boolean
    add_column :ord_trabs, :nCopias, :integer
    add_column :ord_trabs, :urgente, :boolean
    add_column :ord_trabs, :prioridad, :string
    add_column :ord_trabs, :pctdistor, :decimal
    add_column :ord_trabs, :curva_id, :integer
    add_column :ord_trabs, :contacter_id, :integer
    add_column :ord_trabs, :tipomat_id, :integer
    add_column :ord_trabs, :espesor_id, :integer
    add_column :ord_trabs, :sustrato_id, :integer
    remove_column :ord_trabs, :visto
    remove_column :ord_trabs, :fotopol
    remove_column :ord_trabs, :curva
    remove_column :ord_trabs, :sustrato
    change_column :ord_trabs, :distTotalPerim, :decimal, :limit => nil
    change_column :ord_trabs, :nBandas, :decimal, :limit => nil
    change_column :ord_trabs, :nPasos, :decimal, :limit => nil
    change_column :ord_trabs, :distorAncho, :decimal, :limit => nil
    change_column :ord_trabs, :mcTacasV, :decimal, :scale => 3, :precision => 5, :limit => nil
    change_column :ord_trabs, :trapping, :decimal, :limit => nil
    change_column :ord_trabs, :mcTacasH, :decimal, :scale => 3, :precision => 5, :limit => nil
    change_column :ord_trabs, :mcExcesoq, :decimal, :scale => 3, :precision => 5, :limit => nil
    change_column :ord_trabs, :mdi_ancho, :decimal, :limit => nil
    change_column :ord_trabs, :mdi_desarrollo, :decimal, :limit => nil

    remove_index :separacions, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid
    remove_index :separacions, :name => :index_color_assignments_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    add_index :separacions, [:tipomat_id]
    add_index :separacions, [:espesor_id]

    remove_index :existencias, :name => :index_stocks_on_bodega_id rescue ActiveRecord::StatementInvalid
    add_index :existencias, [:unidad_id]

    remove_index :movimientos, :name => :index_movimientos_on_separacion_id rescue ActiveRecord::StatementInvalid
    add_index :movimientos, [:mov_header_id]
    add_index :movimientos, [:bodega_id]
    add_index :movimientos, [:ord_trab_id]
    add_index :movimientos, [:user_id]

    add_index :impresoras, [:curva_id]

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid

    add_index :procesos, [:grupoproc_id]

    remove_index :tareas, :name => :index_tareas_on_asignado_id rescue ActiveRecord::StatementInvalid
    add_index :tareas, [:asignada_a]

    add_index :polimeros, [:tipomat_id]
    add_index :polimeros, [:espesor_id]

    add_index :ord_trabs, [:curva_id]
    add_index :ord_trabs, [:contacter_id]
    add_index :ord_trabs, [:tipomat_id]
    add_index :ord_trabs, [:espesor_id]
    add_index :ord_trabs, [:sustrato_id]
  end

  def self.down
    remove_column :separacions, :tipomat_id
    remove_column :separacions, :espesor_id
    add_column :separacions, :tipomat, :string
    add_column :separacions, :grosor, :string
    change_column :separacions, :ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :area, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :alto, :integer, :limit => 10, :precision => 10, :scale => 0

    remove_column :existencias, :serie
    remove_column :existencias, :unidad_id
    add_column :existencias, :tipo, :string
    add_column :existencias, :unidades, :integer
    change_column :existencias, :existancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :existencias, :existalto, :integer, :limit => 10, :precision => 10, :scale => 0

    remove_column :movimientos, :lote
    remove_column :movimientos, :serie
    remove_column :movimientos, :mov_header_id
    remove_column :movimientos, :bodega_id
    remove_column :movimientos, :ord_trab_id
    remove_column :movimientos, :user_id
    add_column :movimientos, :factura, :integer
    add_column :movimientos, :separacion_id, :integer
    add_column :movimientos, :fecha, :date

    remove_column :impresoras, :curva_id
    change_column :impresoras, :trapdefault, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :aniloxes, :bcm, :integer, :limit => 10, :precision => 10, :scale => 0

    remove_column :procesos, :position
    remove_column :procesos, :prueba
    remove_column :procesos, :reinit
    remove_column :procesos, :varev
    remove_column :procesos, :rev
    remove_column :procesos, :destderev
    remove_column :procesos, :edmeds
    remove_column :procesos, :factura
    remove_column :procesos, :grupoproc_id
    add_column :procesos, :grupo, :string

    remove_column :tareas, :ciclo
    remove_column :tareas, :asignada_a
    add_column :tareas, :asignado_id, :integer
    add_column :tareas, :position, :integer

    remove_column :cilindros, :nombre
    add_column :cilindros, :name, :string
    change_column :cilindros, :distorsion, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :cilindros, :pctDistor, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :cilindros, :espesor, :integer, :limit => 10, :precision => 10, :scale => 0

    remove_column :polimeros, :tipomat_id
    remove_column :polimeros, :espesor_id
    add_column :polimeros, :tipomat, :string
    add_column :polimeros, :espesor, :integer, :limit => 10, :precision => 10, :scale => 0

    remove_column :intervencions, :final

    remove_column :clientes, :sigla
    remove_column :clientes, :correo
    change_column :clientes, :tarifa, :integer, :limit => 10, :precision => 10, :scale => 0

    remove_column :ord_trabs, :vb
    remove_column :ord_trabs, :pol
    remove_column :ord_trabs, :nCopias
    remove_column :ord_trabs, :urgente
    remove_column :ord_trabs, :prioridad
    remove_column :ord_trabs, :pctdistor
    remove_column :ord_trabs, :curva_id
    remove_column :ord_trabs, :contacter_id
    remove_column :ord_trabs, :tipomat_id
    remove_column :ord_trabs, :espesor_id
    remove_column :ord_trabs, :sustrato_id
    add_column :ord_trabs, :visto, :boolean
    add_column :ord_trabs, :fotopol, :string
    add_column :ord_trabs, :curva, :string
    add_column :ord_trabs, :sustrato, :string
    change_column :ord_trabs, :distTotalPerim, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :nBandas, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :nPasos, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :distorAncho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mcTacasV, :integer
    change_column :ord_trabs, :trapping, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mcTacasH, :integer
    change_column :ord_trabs, :mcExcesoq, :integer
    change_column :ord_trabs, :mdi_ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mdi_desarrollo, :integer, :limit => 10, :precision => 10, :scale => 0

    drop_table :grupoprocs
    drop_table :sustratos
    drop_table :unidads
    drop_table :mov_headers
    drop_table :espesors
    drop_table :tipomats
    drop_table :curva_clientes
    drop_table :curvas

    remove_index :separacions, :name => :index_separacions_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :separacions, :name => :index_separacions_on_espesor_id rescue ActiveRecord::StatementInvalid
    add_index :separacions, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'
    add_index :separacions, [:ord_trab_id], :name => 'index_color_assignments_on_ord_trab_id'

    remove_index :existencias, :name => :index_existencias_on_unidad_id rescue ActiveRecord::StatementInvalid
    add_index :existencias, [:bodega_id], :name => 'index_stocks_on_bodega_id'

    remove_index :movimientos, :name => :index_movimientos_on_mov_header_id rescue ActiveRecord::StatementInvalid
    remove_index :movimientos, :name => :index_movimientos_on_bodega_id rescue ActiveRecord::StatementInvalid
    remove_index :movimientos, :name => :index_movimientos_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    remove_index :movimientos, :name => :index_movimientos_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :movimientos, [:separacion_id]

    remove_index :impresoras, :name => :index_impresoras_on_curva_id rescue ActiveRecord::StatementInvalid

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'

    remove_index :procesos, :name => :index_procesos_on_grupoproc_id rescue ActiveRecord::StatementInvalid

    remove_index :tareas, :name => :index_tareas_on_asignada_a rescue ActiveRecord::StatementInvalid
    add_index :tareas, [:asignado_id]

    remove_index :polimeros, :name => :index_polimeros_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :polimeros, :name => :index_polimeros_on_espesor_id rescue ActiveRecord::StatementInvalid

    remove_index :ord_trabs, :name => :index_ord_trabs_on_curva_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_contacter_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_espesor_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_sustrato_id rescue ActiveRecord::StatementInvalid
  end
end
