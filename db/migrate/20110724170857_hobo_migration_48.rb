class HoboMigration48 < ActiveRecord::Migration
  def self.up
    remove_column :intervencions, :state
    remove_column :intervencions, :key_timestamp

    remove_index :intervencions, :name => :index_intervencions_on_state rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :intervencions, :state, :string, :default => "detenida"
    add_column :intervencions, :key_timestamp, :datetime

    add_index :intervencions, [:state]
  end
end
