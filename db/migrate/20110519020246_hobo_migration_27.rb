class HoboMigration27 < ActiveRecord::Migration
  def self.up
    create_table :intervencions do |t|
      t.datetime :inicio
      t.datetime :termino
      t.text     :observaciones
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :tarea_id
      t.integer  :user_id
    end
    add_index :intervencions, [:tarea_id]
    add_index :intervencions, [:user_id]

    create_table :tareas do |t|
      t.text     :instrucciones
      t.date     :fechatope
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :ord_trab_id
      t.integer  :proceso_id
      t.integer  :recurso_id
    end
    add_index :tareas, [:ord_trab_id]
    add_index :tareas, [:proceso_id]
    add_index :tareas, [:recurso_id]

    create_table :procesos do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :recursos do |t|
      t.string   :nombre
      t.text     :descripcion
      t.integer  :velocidad
      t.string   :unidad1
      t.string   :unidad2
      t.integer  :tiempo
      t.string   :indicador
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :proceso_id
    end
    add_index :recursos, [:proceso_id]

    add_column :ord_trabs, :tipofotop, :string
    add_column :ord_trabs, :trapping, :decimal
    add_column :ord_trabs, :curva, :string
    add_column :ord_trabs, :encargado_id, :integer
    change_column :ord_trabs, :supRev, :string, :limit => 255

    remove_index :color_assignments, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid

    add_index :ord_trabs, [:encargado_id]

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :ord_trabs, :tipofotop
    remove_column :ord_trabs, :trapping
    remove_column :ord_trabs, :curva
    remove_column :ord_trabs, :encargado_id
    change_column :ord_trabs, :supRev, :integer

    drop_table :intervencions
    drop_table :tareas
    drop_table :procesos
    drop_table :recursos

    add_index :color_assignments, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'

    remove_index :ord_trabs, :name => :index_ord_trabs_on_encargado_id rescue ActiveRecord::StatementInvalid

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'
  end
end
