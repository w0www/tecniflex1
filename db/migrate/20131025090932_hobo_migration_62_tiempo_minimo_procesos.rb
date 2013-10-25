class HoboMigration62TiempoMinimoProcesos < ActiveRecord::Migration
  def self.up
    add_column :procesos, :minutos_minimo, :integer
  end

  def self.down
    remove_column :procesos, :minutos_minimo
  end
end
