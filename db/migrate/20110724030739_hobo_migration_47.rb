class HoboMigration47 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :state, :string, :default => "creada"
    add_column :ord_trabs, :key_timestamp, :datetime

    add_index :ord_trabs, [:state]
  end

  def self.down
    remove_column :ord_trabs, :state
    remove_column :ord_trabs, :key_timestamp

    remove_index :ord_trabs, :name => :index_ord_trabs_on_state rescue ActiveRecord::StatementInvalid
  end
end
