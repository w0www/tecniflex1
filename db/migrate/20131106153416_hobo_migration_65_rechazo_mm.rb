class HoboMigration65RechazoMm < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :observaciones_matriceria, :boolean
    add_column :intervencions, :observaciones_analisis, :boolean
    add_column :intervencions, :ot_incompleta, :boolean
    add_column :intervencions, :observaciones_micropunto, :boolean
    add_column :intervencions, :ripeo, :boolean
    add_column :intervencions, :distorsion, :boolean
    add_column :intervencions, :texto, :boolean
    add_column :intervencions, :foto, :boolean
    add_column :intervencions, :observaciones_vb, :boolean
    add_column :intervencions, :colores, :string
    add_column :intervencions, :responsable, :integer
    add_column :intervencions, :observaciones_rechazo, :text
  end

  def self.down
    remove_column :intervencions, :observaciones_matriceria
    remove_column :intervencions, :observaciones_analisis
    remove_column :intervencions, :ot_incompleta
    remove_column :intervencions, :observaciones_micropunto
    remove_column :intervencions, :ripeo
    remove_column :intervencions, :distorsion
    remove_column :intervencions, :texto
    remove_column :intervencions, :foto
    remove_column :intervencions, :observaciones_vb
    remove_column :intervencions, :colores
    remove_column :intervencions, :responsable
    remove_column :intervencions, :observaciones_rechazo
  end
end
