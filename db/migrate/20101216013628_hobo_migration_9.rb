class HoboMigration9 < ActiveRecord::Migration
  def self.up
    add_column :clientes, :tarifa, :decimal

    add_column :ord_trabs, :numGuia, :integer
  end

  def self.down
    remove_column :clientes, :tarifa

    remove_column :ord_trabs, :numGuia
  end
end
