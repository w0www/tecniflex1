class HoboMigration68 < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.boolean  :export_to_xml
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :configurations
  end
end
