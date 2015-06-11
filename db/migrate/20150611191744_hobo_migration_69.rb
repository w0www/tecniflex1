class HoboMigration69 < ActiveRecord::Migration
  def self.up
    rename_column :configurations, :export_to_xml, :key
    add_column :configurations, :value, :boolean
    change_column :configurations, :key, :string, :limit => 255
  end

  def self.down
    rename_column :configurations, :key, :export_to_xml
    remove_column :configurations, :value
    change_column :configurations, :export_to_xml, :boolean
  end
end
