class HoboMigration68 < ActiveRecord::Migration
  def self.up
    create_table :curvas do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :ord_trabs, :nCopias, :integer

    add_column :users, :iniciales, :string
  end

  def self.down
    remove_column :ord_trabs, :nCopias

    remove_column :users, :iniciales

    drop_table :curvas
  end
end
