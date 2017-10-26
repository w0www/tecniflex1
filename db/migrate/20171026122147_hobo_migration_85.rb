class HoboMigration85 < ActiveRecord::Migration
  def self.up
    change_column :configurations, :value, :string, :limit => 255
  end

  def self.down
    change_column :configurations, :value, :boolean
  end
end
