class HoboMigration22 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :mcGuia, :boolean
    add_column :ord_trabs, :mcGuiacol, :string
    add_column :ord_trabs, :mcMPunto, :boolean
    add_column :ord_trabs, :mcMPuntocol, :string
    add_column :ord_trabs, :mcCruces, :boolean
    add_column :ord_trabs, :mcCrucescol, :string
    add_column :ord_trabs, :mcTacas, :boolean
    add_column :ord_trabs, :mcTacasH, :integer
    add_column :ord_trabs, :mcTacasV, :integer
    add_column :ord_trabs, :mcTacascol, :string
    add_column :ord_trabs, :mcTiras, :boolean
    add_column :ord_trabs, :mcTirascol, :string
    add_column :ord_trabs, :mcExceso, :boolean
    add_column :ord_trabs, :mcExcesoq, :integer
    add_column :ord_trabs, :mcExcesocol, :string
    add_column :ord_trabs, :mcMarcas, :boolean
    add_column :ord_trabs, :mcMarcascol, :string
    add_column :ord_trabs, :mcPimp, :boolean
    add_column :ord_trabs, :mcPimpcol, :string
  end

  def self.down
    remove_column :ord_trabs, :mcGuia
    remove_column :ord_trabs, :mcGuiacol
    remove_column :ord_trabs, :mcMPunto
    remove_column :ord_trabs, :mcMPuntocol
    remove_column :ord_trabs, :mcCruces
    remove_column :ord_trabs, :mcCrucescol
    remove_column :ord_trabs, :mcTacas
    remove_column :ord_trabs, :mcTacasH
    remove_column :ord_trabs, :mcTacasV
    remove_column :ord_trabs, :mcTacascol
    remove_column :ord_trabs, :mcTiras
    remove_column :ord_trabs, :mcTirascol
    remove_column :ord_trabs, :mcExceso
    remove_column :ord_trabs, :mcExcesoq
    remove_column :ord_trabs, :mcExcesocol
    remove_column :ord_trabs, :mcMarcas
    remove_column :ord_trabs, :mcMarcascol
    remove_column :ord_trabs, :mcPimp
    remove_column :ord_trabs, :mcPimpcol
  end
end
