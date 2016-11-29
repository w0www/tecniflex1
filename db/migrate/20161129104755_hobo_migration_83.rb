class HoboMigration83 < ActiveRecord::Migration
  def self.up
    add_column :intervencions, :procdest, :string
  end

  def self.down
    remove_column :intervencions, :procdest
  end
end
