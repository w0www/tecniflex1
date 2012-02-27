class HoboMigration82 < ActiveRecord::Migration
  def self.up
    create_table :tipomats do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :espesors do |t|
      t.decimal  :calibre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :recipes do |t|
      t.string   :title
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :polimeros, :tipomat_id, :integer
    add_column :polimeros, :espesor_id, :integer
    remove_column :polimeros, :tipomat
    remove_column :polimeros, :espesor

    add_index :polimeros, [:tipomat_id]
    add_index :polimeros, [:espesor_id]
  end

  def self.down
    remove_column :polimeros, :tipomat_id
    remove_column :polimeros, :espesor_id
    add_column :polimeros, :tipomat, :string
    add_column :polimeros, :espesor, :decimal

    drop_table :tipomats
    drop_table :espesors
    drop_table :recipes

    remove_index :polimeros, :name => :index_polimeros_on_tipomat_id rescue ActiveRecord::StatementInvalid
    remove_index :polimeros, :name => :index_polimeros_on_espesor_id rescue ActiveRecord::StatementInvalid
  end
end
