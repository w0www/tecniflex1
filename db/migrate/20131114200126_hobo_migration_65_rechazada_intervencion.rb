class HoboMigration65RechazadaIntervencion < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :rechazada, :boolean
  end

  def self.down
    remove_column :intervencions, :rechazada
  end
end
