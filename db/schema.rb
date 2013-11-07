# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131106153416) do

  create_table "aniloxes", :force => true do |t|
    t.integer  "lineatura"
    t.decimal  "bcm",          :precision => 5, :scale => 2
    t.string   "marca"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "impresora_id"
  end

  add_index "aniloxes", ["impresora_id"], :name => "index_aniloxes_on_impresora_id"

  create_table "bodegas", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cilindros", :force => true do |t|
    t.integer  "distorsion",   :limit => 10, :precision => 10, :scale => 0
    t.decimal  "pctDistor",                  :precision => 5,  :scale => 3
    t.string   "duplo"
    t.decimal  "espesor",                    :precision => 3,  :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "impresora_id"
    t.string   "nombre"
  end

  add_index "cilindros", ["impresora_id"], :name => "index_cilindros_on_impresora_id"

  create_table "clientes", :force => true do |t|
    t.string   "name"
    t.string   "razsocial"
    t.string   "rut"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "fpago"
    t.string   "plazopago"
    t.string   "descuento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tarifa",     :limit => 10, :precision => 10, :scale => 0
    t.string   "sigla"
    t.string   "correo"
  end

  create_table "contactos", :force => true do |t|
    t.string   "name"
    t.string   "cargo"
    t.string   "telefono"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cliente_id"
  end

  add_index "contactos", ["cliente_id"], :name => "index_contactos_on_cliente_id"

  create_table "curva_clientes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "curva_id"
    t.integer  "cliente_id"
  end

  add_index "curva_clientes", ["cliente_id"], :name => "index_curva_clientes_on_cliente_id"
  add_index "curva_clientes", ["curva_id"], :name => "index_curva_clientes_on_curva_id"

  create_table "curvas", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.string   "impresion"
    t.string   "lineatura"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipomat_id"
    t.integer  "espesor_id"
    t.integer  "sustrato_id"
  end

  add_index "curvas", ["espesor_id"], :name => "index_curvas_on_espesor_id"
  add_index "curvas", ["sustrato_id"], :name => "index_curvas_on_sustrato_id"
  add_index "curvas", ["tipomat_id"], :name => "index_curvas_on_tipomat_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "espesors", :force => true do |t|
    t.decimal  "calibre",     :precision => 3, :scale => 2
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "existencias", :force => true do |t|
    t.integer  "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bodega_id"
    t.integer  "existalto",   :limit => 10, :precision => 10, :scale => 0
    t.integer  "existancho",  :limit => 10, :precision => 10, :scale => 0
    t.integer  "polimero_id"
    t.string   "codigo"
    t.integer  "numfact"
    t.string   "lote"
    t.string   "serie"
    t.integer  "unidad_id"
  end

  add_index "existencias", ["bodega_id"], :name => "index_existencias_on_bodega_id"
  add_index "existencias", ["bodega_id"], :name => "index_stocks_on_bodega_id"
  add_index "existencias", ["polimero_id"], :name => "index_existencias_on_polimero_id"
  add_index "existencias", ["unidad_id"], :name => "index_existencias_on_unidad_id"

  create_table "grupoprocs", :force => true do |t|
    t.integer  "position"
    t.string   "nombre"
    t.string   "abreviacion"
    t.boolean  "tablero"
    t.boolean  "asignar"
    t.boolean  "saevb"
    t.boolean  "saemtz"
    t.boolean  "saemtje"
    t.boolean  "saeptr"
    t.boolean  "saepol"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "impresoras", :force => true do |t|
    t.string   "name"
    t.integer  "trapdefault", :limit => 10, :precision => 10, :scale => 0
    t.string   "bumpcurve"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cliente_id"
    t.integer  "curva_id"
  end

  add_index "impresoras", ["cliente_id"], :name => "index_impresoras_on_cliente_id"
  add_index "impresoras", ["curva_id"], :name => "index_impresoras_on_curva_id"

  create_table "intervencions", :force => true do |t|
    t.datetime "inicio"
    t.datetime "termino"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tarea_id"
    t.integer  "user_id"
    t.boolean  "final"
    t.boolean  "observaciones_matriceria"
    t.boolean  "observaciones_analisis"
    t.boolean  "ot_incompleta"
    t.boolean  "observaciones_micropunto"
    t.boolean  "ripeo"
    t.boolean  "distorsion"
    t.boolean  "texto"
    t.boolean  "foto"
    t.boolean  "observaciones_vb"
    t.string   "colores"
    t.integer  "responsable"
    t.text     "observaciones_rechazo"
  end

  add_index "intervencions", ["tarea_id"], :name => "index_intervencions_on_tarea_id"
  add_index "intervencions", ["user_id"], :name => "index_intervencions_on_user_id"

  create_table "mov_headers", :force => true do |t|
    t.integer  "factura"
    t.date     "fecha"
    t.string   "proveedor"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movimientos", :force => true do |t|
    t.integer  "cantidad"
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "polimero_id"
    t.string   "lote"
    t.string   "serie"
    t.integer  "mov_header_id"
    t.integer  "bodega_id"
    t.integer  "ord_trab_id"
    t.integer  "user_id"
  end

  add_index "movimientos", ["bodega_id"], :name => "index_movimientos_on_bodega_id"
  add_index "movimientos", ["mov_header_id"], :name => "index_movimientos_on_mov_header_id"
  add_index "movimientos", ["ord_trab_id"], :name => "index_movimientos_on_ord_trab_id"
  add_index "movimientos", ["polimero_id"], :name => "index_movimientos_on_polimero_id"
  add_index "movimientos", ["user_id"], :name => "index_movimientos_on_user_id"

  create_table "ord_trabs", :force => true do |t|
    t.integer  "numOT"
    t.integer  "numFact"
    t.date     "fecha"
    t.integer  "clase"
    t.datetime "fechaEntrega"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "numGuia"
    t.boolean  "mtz"
    t.boolean  "mtje"
    t.boolean  "ptr"
    t.boolean  "mpFTP"
    t.integer  "mpFTPq"
    t.boolean  "mpFTPdev"
    t.boolean  "mpPel"
    t.integer  "mpPelq"
    t.boolean  "mpPeldev"
    t.boolean  "mpImp"
    t.integer  "mpImpq"
    t.boolean  "mpImpdev"
    t.boolean  "mpMgr"
    t.integer  "mpMgrq"
    t.boolean  "mpMgrdev"
    t.boolean  "mpOpt"
    t.integer  "mpOptq"
    t.boolean  "mpOptdev"
    t.boolean  "mpPtr"
    t.integer  "mpPtrq"
    t.boolean  "mpPtrdev"
    t.boolean  "mcGuia"
    t.string   "mcGuiacol"
    t.boolean  "mcMPunto"
    t.string   "mcMPuntocol"
    t.boolean  "mcCruces"
    t.string   "mcCrucescol"
    t.boolean  "mcTacas"
    t.decimal  "mcTacasH",                     :precision => 5,  :scale => 3
    t.decimal  "mcTacasV",                     :precision => 5,  :scale => 3
    t.string   "mcTacascol"
    t.boolean  "mcTiras"
    t.string   "mcTirascol"
    t.boolean  "mcExceso"
    t.decimal  "mcExcesoq",                    :precision => 5,  :scale => 3
    t.string   "mcExcesocol"
    t.boolean  "mcMarcas"
    t.string   "mcMarcascol"
    t.boolean  "mcPimp"
    t.string   "mcPimpcol"
    t.string   "nomprod"
    t.string   "codTflex"
    t.string   "codCliente"
    t.integer  "mdi_desarrollo", :limit => 10, :precision => 10, :scale => 0
    t.integer  "mdi_ancho",      :limit => 10, :precision => 10, :scale => 0
    t.string   "barcode"
    t.string   "colorBarcode"
    t.integer  "dispBandas"
    t.integer  "distTotalPerim", :limit => 10, :precision => 10, :scale => 0
    t.integer  "distorAncho",    :limit => 10, :precision => 10, :scale => 0
    t.integer  "nPasos",         :limit => 10, :precision => 10, :scale => 0
    t.integer  "nBandas",        :limit => 10, :precision => 10, :scale => 0
    t.integer  "colorUnion"
    t.string   "supRev"
    t.integer  "cliente_id"
    t.integer  "impresora_id"
    t.integer  "cilindro_id"
    t.string   "tipofotop"
    t.integer  "trapping",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "encargado_id"
    t.string   "state",                                                       :default => "creada"
    t.datetime "key_timestamp"
    t.string   "cfinal"
    t.string   "mcGuiaapy"
    t.string   "mcMPuntoapy"
    t.string   "mcCrucesapy"
    t.string   "mcTacasapy"
    t.string   "mcTirasapy"
    t.string   "mcExcesoapy"
    t.string   "mcMarcasapy"
    t.string   "mcPimpapy"
    t.integer  "version"
    t.boolean  "vb"
    t.boolean  "pol"
    t.integer  "nCopias"
    t.boolean  "urgente"
    t.string   "prioridad"
    t.integer  "pctdistor",      :limit => 10, :precision => 10, :scale => 0
    t.integer  "curva_id"
    t.integer  "contacter_id"
    t.integer  "tipomat_id"
    t.integer  "espesor_id"
    t.integer  "sustrato_id"
  end

  add_index "ord_trabs", ["cilindro_id"], :name => "index_ord_trabs_on_cilindro_id"
  add_index "ord_trabs", ["cliente_id"], :name => "index_ord_trabs_on_cliente_id"
  add_index "ord_trabs", ["contacter_id"], :name => "index_ord_trabs_on_contacter_id"
  add_index "ord_trabs", ["curva_id"], :name => "index_ord_trabs_on_curva_id"
  add_index "ord_trabs", ["encargado_id"], :name => "index_ord_trabs_on_encargado_id"
  add_index "ord_trabs", ["espesor_id"], :name => "index_ord_trabs_on_espesor_id"
  add_index "ord_trabs", ["impresora_id"], :name => "index_ord_trabs_on_impresora_id"
  add_index "ord_trabs", ["state"], :name => "index_ord_trabs_on_state"
  add_index "ord_trabs", ["sustrato_id"], :name => "index_ord_trabs_on_sustrato_id"
  add_index "ord_trabs", ["tipomat_id"], :name => "index_ord_trabs_on_tipomat_id"

  create_table "polimeros", :force => true do |t|
    t.string   "tipo"
    t.string   "nombre"
    t.integer  "alto"
    t.integer  "ancho"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cantcaja"
    t.integer  "tipomat_id"
    t.integer  "espesor_id"
  end

  add_index "polimeros", ["espesor_id"], :name => "index_polimeros_on_espesor_id"
  add_index "polimeros", ["tipomat_id"], :name => "index_polimeros_on_tipomat_id"

  create_table "procesos", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sucesor_id"
    t.integer  "position"
    t.boolean  "prueba"
    t.boolean  "reinit"
    t.boolean  "varev"
    t.boolean  "rev"
    t.boolean  "destderev"
    t.boolean  "edmeds"
    t.boolean  "factura",        :default => false
    t.integer  "grupoproc_id"
    t.integer  "minutos_minimo"
  end

  add_index "procesos", ["grupoproc_id"], :name => "index_procesos_on_grupoproc_id"
  add_index "procesos", ["sucesor_id"], :name => "index_procesos_on_sucesor_id"

  create_table "pruebas", :force => true do |t|
    t.boolean  "aprob_int"
    t.boolean  "aprob_cliente"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipoprueba_id"
    t.integer  "ord_trab_id"
  end

  add_index "pruebas", ["ord_trab_id"], :name => "index_pruebas_on_ord_trab_id"
  add_index "pruebas", ["tipoprueba_id"], :name => "index_pruebas_on_tipoprueba_id"

  create_table "recursos", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.integer  "velocidad"
    t.string   "unidad1"
    t.string   "unidad2"
    t.integer  "tiempo"
    t.string   "indicador"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "proceso_id"
  end

  add_index "recursos", ["proceso_id"], :name => "index_recursos_on_proceso_id"

  create_table "separacions", :force => true do |t|
    t.integer  "position"
    t.string   "anilox"
    t.string   "lpi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ord_trab_id"
    t.string   "color"
    t.integer  "area",        :limit => 10, :precision => 10, :scale => 0
    t.integer  "alto",        :limit => 10, :precision => 10, :scale => 0
    t.integer  "ancho",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "tipomat_id"
    t.integer  "espesor_id"
  end

  add_index "separacions", ["espesor_id"], :name => "index_separacions_on_espesor_id"
  add_index "separacions", ["ord_trab_id"], :name => "index_color_assignments_on_ord_trab_id"
  add_index "separacions", ["ord_trab_id"], :name => "index_color_assignments_on_producto_id"
  add_index "separacions", ["ord_trab_id"], :name => "index_separacions_on_ord_trab_id"
  add_index "separacions", ["tipomat_id"], :name => "index_separacions_on_tipomat_id"

  create_table "sustratos", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tareas", :force => true do |t|
    t.text     "instrucciones"
    t.date     "fechatope"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ord_trab_id"
    t.integer  "proceso_id"
    t.integer  "recurso_id"
    t.string   "state",         :default => "creada"
    t.datetime "key_timestamp"
    t.integer  "ciclo"
    t.integer  "asignada_a"
  end

  add_index "tareas", ["asignada_a"], :name => "index_tareas_on_asignada_a"
  add_index "tareas", ["ord_trab_id"], :name => "index_tareas_on_ord_trab_id"
  add_index "tareas", ["proceso_id"], :name => "index_tareas_on_proceso_id"
  add_index "tareas", ["recurso_id"], :name => "index_tareas_on_recurso_id"
  add_index "tareas", ["state"], :name => "index_tareas_on_state"

  create_table "tintas", :force => true do |t|
    t.integer  "posicion"
    t.string   "anilox"
    t.string   "lpi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ord_trab_id"
  end

  add_index "tintas", ["ord_trab_id"], :name => "index_tintas_on_ord_trab_id"
  add_index "tintas", ["ord_trab_id"], :name => "index_tintas_on_producto_id"

  create_table "tipomats", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipopruebas", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unidads", :force => true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.integer  "cantunimenor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unimenor_id"
  end

  add_index "unidads", ["unimenor_id"], :name => "index_unidads_on_unimenor_id"

  create_table "user_labors", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "proceso_id"
  end

  add_index "user_labors", ["proceso_id"], :name => "index_user_labors_on_proceso_id"
  add_index "user_labors", ["user_id"], :name => "index_user_labors_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
    t.string   "rol"
    t.string   "iniciales"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
