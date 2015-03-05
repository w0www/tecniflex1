class OpcionesDeRechazo < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :ot_error, :boolean
    add_column :intervencions, :observaciones_montaje, :boolean
  end

  def self.down
    remove_column :intervencions, :ot_error
    remove_column :intervencions, :observaciones_montaje
  end
end
