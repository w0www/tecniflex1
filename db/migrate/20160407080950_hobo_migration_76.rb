class HoboMigration76 < ActiveRecord::Migration
  def self.up
    add_column :list_barcodes, :num_char, :integer
  end

  def self.down
    remove_column :list_barcodes, :num_char
  end
end
