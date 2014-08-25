class HoboMigration10 < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.string   :name
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :tintas do |t|
      t.integer  :posicion
      t.string   :anilox
      t.string   :lpi
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :color_id
      t.integer  :producto_id
    end
    add_index :tintas, [:color_id]
    add_index :tintas, [:producto_id]
  end

  def self.down
    drop_table :colors
    drop_table :tintas
  end
end
