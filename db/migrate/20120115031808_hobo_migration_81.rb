class HoboMigration81 < ActiveRecord::Migration
  def self.up
    add_column :cilindros, :pctDistor, :decimal, :precision => 5, :scale => 3
  end

  def self.down
    remove_column :cilindros, :pctDistor
  end
end
