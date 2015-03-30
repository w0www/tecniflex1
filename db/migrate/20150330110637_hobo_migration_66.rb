class HoboMigration66 < ActiveRecord::Migration
  def self.up
    change_column :existencias, :existancho, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :existencias, :existalto, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil

    change_column :cilindros, :distorsion, :decimal, :limit => nil

    change_column :clientes, :tarifa, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil

    change_column :separacions, :ancho, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :separacions, :area, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :separacions, :alto, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil

    change_column :impresoras, :trapdefault, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil

    change_column :ord_trabs, :mcTacasV, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :nBandas, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :mcTacasH, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :mdi_desarrollo, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :distorAncho, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :trapping, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :mcExcesoq, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :distTotalPerim, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :pctdistor, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :mdi_ancho, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
    change_column :ord_trabs, :nPasos, :decimal, :scale => 2, :precision => 8, :default => 0, :limit => nil
  end

  def self.down
    change_column :existencias, :existancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :existencias, :existalto, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :cilindros, :distorsion, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :clientes, :tarifa, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :separacions, :ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :area, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :alto, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :impresoras, :trapdefault, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :ord_trabs, :mcTacasV, :decimal, :precision => 5,  :scale => 3
    change_column :ord_trabs, :nBandas, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mcTacasH, :decimal, :precision => 5,  :scale => 3
    change_column :ord_trabs, :mdi_desarrollo, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :distorAncho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :trapping, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mcExcesoq, :decimal, :precision => 5,  :scale => 3
    change_column :ord_trabs, :distTotalPerim, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :pctdistor, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mdi_ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :nPasos, :integer, :limit => 10, :precision => 10, :scale => 0
  end
end
