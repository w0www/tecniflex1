class HoboMigration47 < ActiveRecord::Migration
  def self.up

    add_index :ord_trabs, [:state]
  end

  def self.down

    remove_index :ord_trabs, :name => :index_ord_trabs_on_state rescue ActiveRecord::StatementInvalid
  end
end
