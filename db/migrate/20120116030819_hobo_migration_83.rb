class HoboMigration83 < ActiveRecord::Migration
  def self.up
    create_table :sustratos do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :ord_trabs, :tipomat_id, :integer
    add_column :ord_trabs, :espesor_id, :integer
    add_column :ord_trabs, :sustrato_id, :integer
    remove_column :ord_trabs, :sustrato
    remove_column :ord_trabs, :fotopol

    add_column :curvas, :tipomat_id, :integer
    add_column :curvas, :espesor_id, :integer
    remove_column :curvas, :espesor
    remove_column :curvas, :polimero

    add_column :separacions, :tipomat_id, :integer
    add_column :separacions, :espesor_id, :integer
    remove_column :separacions, :tipomat
    remove_column :separacions, :grosor

    add_index :ord_trabs, [:tipomat_id]
    add_index :ord_trabs, [:espesor_id]
    add_index :ord_trabs, [:sustrato_id]

    add_index :curvas, [:tipomat_id]
    add_index :curvas, [:espesor_id]

    add_index :separacions, [:tipomat_id]
    add_index :separacions, [:espesor_id]
  end

  def self.down
    remove_column :ord_trabs, :tipomat_id
    remove_column :ord_trabs, :espesor_id
    remove_column :ord_trabs, :sustrato_id
    add_column :ord_trabs, :sustrato, :string
    add_column :ord_trabs, :fotopol, :string

    remove_column :curvas, :tipomat_id
    remove_column :curvas, :espesor_id
    add_column :curvas, :espesor, :string
    add_column :curvas, :polimero, :string

    remove_column :separacions, :tipomat_id
    remove_column :separacions, :espesor_id
    add_column :separacions, :tipomat, :string
    add_column :separacions, :grosor, :string

    drop_table :sustratos

    remove_index :ord_trabs, :name => :index_ord_trabs_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_espesor_id rescue ActiveRecord::StatementInvalid
    remove_index :ord_trabs, :name => :index_ord_trabs_on_sustrato_id rescue ActiveRecord::StatementInvalid

    remove_index :curvas, :name => :index_curvas_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :curvas, :name => :index_curvas_on_espesor_id rescue ActiveRecord::StatementInvalid

    remove_index :separacions, :name => :index_separacions_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :separacions, :name => :index_separacions_on_espesor_id rescue ActiveRecord::StatementInvalid
  end
end
