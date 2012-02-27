class HoboMigration67 < ActiveRecord::Migration
  def self.up
    create_table :unidads do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :existencias, :unidad_id, :integer

    add_index :existencias, [:unidad_id]
  end

  def self.down
    remove_column :existencias, :unidad_id

    drop_table :unidads

    remove_index :existencias, :name => :index_existencias_on_unidad_id rescue ActiveRecord::StatementInvalid
  end
end
