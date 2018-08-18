class HoboMigration88 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :tipoesko, :string
  end

  def self.down
    remove_column :ord_trabs, :tipoesko
  end
end
