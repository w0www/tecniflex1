class HoboMigration12 < ActiveRecord::Migration
  def self.up
    create_table :pruebas do |t|
      t.boolean  :aprob_int
      t.boolean  :aprob_cliente
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :tipoprueba_id
      t.integer  :ord_trab_id
    end
    add_index :pruebas, [:tipoprueba_id]
    add_index :pruebas, [:ord_trab_id]

    create_table :tipopruebas do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :contactos, :cliente_id, :integer

    add_index :contactos, [:cliente_id]
  end

  def self.down
    remove_column :contactos, :cliente_id

    drop_table :pruebas
    drop_table :tipopruebas

    remove_index :contactos, :name => :index_contactos_on_cliente_id rescue ActiveRecord::StatementInvalid
  end
end
