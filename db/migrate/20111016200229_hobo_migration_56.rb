class HoboMigration56 < ActiveRecord::Migration
  def self.up
    add_column :existencias, :numfact, :integer
    add_column :existencias, :lote, :string
  end

  def self.down
    remove_column :existencias, :numfact
    remove_column :existencias, :lote
  end
end
