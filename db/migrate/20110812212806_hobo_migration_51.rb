class HoboMigration51 < ActiveRecord::Migration
  def self.up
    create_table :aniloxes do |t|
      t.string   :nombre
      t.integer  :lineatura
      t.decimal  :bcm
      t.string   :marca
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :impresora_id
    end
    add_index :aniloxes, [:impresora_id]
  end

  def self.down
    drop_table :aniloxes
  end
end
