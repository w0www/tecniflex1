class HoboMigration53 < ActiveRecord::Migration
  def self.up
    remove_column :polimeros, :existencia_id

    remove_index :polimeros, :name => :index_polimeros_on_existencia_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :polimeros, :existencia_id, :integer

    add_index :polimeros, [:existencia_id]
  end
end
