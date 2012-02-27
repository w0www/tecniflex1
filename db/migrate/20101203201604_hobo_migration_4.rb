class HoboMigration4 < ActiveRecord::Migration
  def self.up
    create_table :impresoras do |t|
      t.string   :name
      t.decimal  :trapdefault
      t.string   :bumpcurve
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :impresoras
  end
end
