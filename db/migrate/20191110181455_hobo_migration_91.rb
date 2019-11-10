class HoboMigration91 < ActiveRecord::Migration
  def self.up
    add_column :users, :fecha_actualizacion_password, :date

  end

  def self.down
    remove_column :users, :fecha_actualizacion_password
  end
end
