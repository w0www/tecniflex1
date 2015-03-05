class HoboMigration64 < ActiveRecord::Migration
  def self.up
    remove_column :curvas, :impresora_id

    change_column :existencias, :existancho, :decimal, :limit => nil
    change_column :existencias, :existalto, :decimal, :limit => nil

    remove_column :impresoras, :curva
    change_column :impresoras, :trapdefault, :decimal, :limit => nil

    change_column :clientes, :tarifa, :decimal, :limit => nil

    change_column :separacions, :alto, :decimal, :limit => nil
    change_column :separacions, :ancho, :decimal, :limit => nil
    change_column :separacions, :area, :decimal, :limit => nil

    change_column :cilindros, :distorsion, :decimal, :limit => nil

    change_column :ord_trabs, :mdi_desarrollo, :decimal, :limit => nil
    change_column :ord_trabs, :mdi_ancho, :decimal, :limit => nil
    change_column :ord_trabs, :nPasos, :decimal, :limit => nil
    change_column :ord_trabs, :trapping, :decimal, :limit => nil
    change_column :ord_trabs, :distTotalPerim, :decimal, :limit => nil
    change_column :ord_trabs, :nBandas, :decimal, :limit => nil
    change_column :ord_trabs, :distorAncho, :decimal, :limit => nil
    change_column :ord_trabs, :pctdistor, :decimal, :limit => nil

    remove_index :curvas, :name => :index_curvas_on_impresora_id rescue ActiveRecord::StatementInvalid

    remove_index :existencias, :name => :index_stocks_on_bodega_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_producto_id rescue ActiveRecord::StatementInvalid

    remove_index :separacions, :name => :index_color_assignments_on_producto_id rescue ActiveRecord::StatementInvalid
    remove_index :separacions, :name => :index_color_assignments_on_ord_trab_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :curvas, :impresora_id, :integer

    change_column :existencias, :existancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :existencias, :existalto, :integer, :limit => 10, :precision => 10, :scale => 0

    add_column :impresoras, :curva, :string
    change_column :impresoras, :trapdefault, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :clientes, :tarifa, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :separacions, :alto, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :separacions, :area, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :cilindros, :distorsion, :integer, :limit => 10, :precision => 10, :scale => 0

    change_column :ord_trabs, :mdi_desarrollo, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :mdi_ancho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :nPasos, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :trapping, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :distTotalPerim, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :nBandas, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :distorAncho, :integer, :limit => 10, :precision => 10, :scale => 0
    change_column :ord_trabs, :pctdistor, :integer, :limit => 10, :precision => 10, :scale => 0

    add_index :curvas, [:impresora_id]

    add_index :existencias, [:bodega_id], :name => 'index_stocks_on_bodega_id'

    add_index :tintas, [:ord_trab_id], :name => 'index_tintas_on_producto_id'

    add_index :separacions, [:ord_trab_id], :name => 'index_color_assignments_on_producto_id'
    add_index :separacions, [:ord_trab_id], :name => 'index_color_assignments_on_ord_trab_id'
  end
end
