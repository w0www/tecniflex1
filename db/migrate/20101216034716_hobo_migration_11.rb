class HoboMigration11 < ActiveRecord::Migration
  def self.up
    create_table :color_assignments do |t|
      t.integer  :posicion
      t.string   :anilox
      t.string   :lpi
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :color_id
      t.integer  :producto_id
    end
    add_index :color_assignments, [:color_id]
    add_index :color_assignments, [:producto_id]
  end

  def self.down
    drop_table :color_assignments
  end
end
