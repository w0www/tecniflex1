class HoboMigration89 < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :hora_entrada, :datetime
    add_column :intervencions, :hora_salida, :datetime
    add_column :intervencions, :operador, :string
    add_column :intervencions, :acabado, :string
  end

  def self.down
    remove_column :intervencions, :hora_entrada
    remove_column :intervencions, :hora_salida
    remove_column :intervencions, :operador
    remove_column :intervencions, :acabado
  end
end
