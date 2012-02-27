class HoboMigration61 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :pctdistor, :decimal

    add_column :clientes, :sigla, :string

    remove_column :cilindros, :pctDistor
  end

  def self.down
    remove_column :ord_trabs, :pctdistor

    remove_column :clientes, :sigla

    add_column :cilindros, :pctDistor, :decimal
  end
end
