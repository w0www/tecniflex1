class HoboMigration14 < ActiveRecord::Migration
  def self.up
    change_column :ord_trabs, :fechaEntrega, :date
  end

  def self.down
    change_column :ord_trabs, :fechaEntrega, :integer
  end
end
