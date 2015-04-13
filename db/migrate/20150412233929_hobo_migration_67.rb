class HoboMigration67 < ActiveRecord::Migration
  def self.up
    change_column :cilindros, :distorsion, :decimal, :scale => 3, :precision => 8, :limit => nil
    change_column :cilindros, :pctDistor, :decimal, :scale => 3, :precision => 8, :limit => nil     
    change_column :cilindros, :espesor, :decimal, :scale => 3, :precision => 8, :limit => nil
  end

  def self.down
    change_column :cilindros, :distorsion, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :cilindros, :pctDistor, :decimal, :scale => 3, :precision => 5, :limit => nil
    change_column :cilindros, :espesor, :decimal, :scale => 2, :precision => 3, :limit => nil
  end
end
