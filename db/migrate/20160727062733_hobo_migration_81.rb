class HoboMigration81 < ActiveRecord::Migration
  def self.up
    create_table :auditorias do |t|
      t.string   :tipo
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :auditorias
  end
end
