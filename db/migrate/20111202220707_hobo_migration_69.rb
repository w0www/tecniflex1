class HoboMigration69 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :curva_id, :integer

    add_index :ord_trabs, [:curva_id]
  end

  def self.down
    remove_column :ord_trabs, :curva_id

    remove_index :ord_trabs, :name => :index_ord_trabs_on_curva_id rescue ActiveRecord::StatementInvalid
  end
end
