class HoboMigration77 < ActiveRecord::Migration
  def self.up
    create_table :curva_clientes do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :curva_id
      t.integer  :cliente_id
    end
    add_index :curva_clientes, [:curva_id]
    add_index :curva_clientes, [:cliente_id]

    add_column :curvas, :impresion, :string
    add_column :curvas, :sustrato, :string
    add_column :curvas, :espesor, :string
    add_column :curvas, :polimero, :string

    add_column :impresoras, :curva_id, :integer

    add_index :impresoras, [:curva_id]
  end

  def self.down
    remove_column :curvas, :impresion
    remove_column :curvas, :sustrato
    remove_column :curvas, :espesor
    remove_column :curvas, :polimero

    remove_column :impresoras, :curva_id

    drop_table :curva_clientes

    remove_index :impresoras, :name => :index_impresoras_on_curva_id rescue ActiveRecord::StatementInvalid
  end
end
