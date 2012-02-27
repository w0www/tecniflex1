class HoboMigration3 < ActiveRecord::Migration
  def self.up
    create_table :contactos do |t|
      t.string   :name
      t.string   :cargo
      t.string   :telefono
      t.string   :email
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :contactos
  end
end
