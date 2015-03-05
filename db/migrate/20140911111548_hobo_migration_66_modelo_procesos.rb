class HoboMigration66ModeloProcesos < ActiveRecord::Migration
  def self.up
    change_column :impresoras, :trapdefault, :decimal, :limit => nil

    change_column :ord_trabs, :nBandas, :decimal, :limit => nil
    change_column :ord_trabs, :distorAncho, :decimal, :limit => nil
    change_column :ord_trabs, :mdi_desarrollo, :decimal, :limit => nil
    change_column :ord_trabs, :cfinal, :string, :limit => 255
    change_column :ord_trabs, :nPasos, :decimal, :limit => nil
    change_column :ord_trabs, :mdi_ancho, :decimal, :limit => nil
    change_column :ord_trabs, :trapping, :decimal, :limit => nil
    change_column :ord_trabs, :pctdistor, :decimal, :limit => nil
    change_column :ord_trabs, :distTotalPerim, :decimal, :limit => nil

    change_column :separacions, :alto, :decimal, :limit => nil
    change_column :separacions, :ancho, :decimal, :limit => nil
    change_column :separacions, :area, :decimal, :limit => nil

    change_column :clientes, :tarifa, :decimal, :limit => nil

    rename_column :procesos, :edmeds, :edicion_medidas
    rename_column :procesos, :destderev, :volver_desde_revision
    rename_column :procesos, :varev, :volver_a_revision
    rename_column :procesos, :reinit, :reiniciar

    change_column :existencias, :existancho, :decimal, :limit => nil
    change_column :existencias, :existalto, :decimal, :limit => nil

    change_column :cilindros, :distorsion, :decimal, :limit => nil
  end

  def self.down
    change_column :impresoras, :trapdefault, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :ord_trabs, :nBandas, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :distorAncho, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :mdi_desarrollo, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :cfinal, :string, :limit => 100
    change_column :ord_trabs, :nPasos, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :mdi_ancho, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :trapping, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :pctdistor, :integer, :limit => 10,  :precision => 10, :scale => 0
    change_column :ord_trabs, :distTotalPerim, :integer, :limit => 10,  :precision => 10, :scale => 0

    change_column :separacions, :alto, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :area, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :clientes, :tarifa, :integer, :limit => 10, :precision => 10, :scale => 0

    rename_column :procesos, :edicion_medidas, :edmeds
    rename_column :procesos, :volver_desde_revision, :destderev
    rename_column :procesos, :volver_a_revision, :varev
    rename_column :procesos, :reiniciar, :reinit

    change_column :existencias, :existancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :existencias, :existalto, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :cilindros, :distorsion, :integer, :limit => 10, :precision => 10, :scale => 0
  end
end
