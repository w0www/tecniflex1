class HoboMigration77 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :barcodecopy, :string
  end

  def self.down
    remove_column :ord_trabs, :barcodecopy
  end
end
