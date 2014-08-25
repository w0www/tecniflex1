class HoboMigration44 < ActiveRecord::Migration
  def self.up
    rename_table :color_assignments, :separacions

    remove_index :separacions, :name => :index_color_assignments_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    add_index :separacions, [:ord_trab_id]
  end

  def self.down
    rename_table :separacions, :color_assignments

    remove_index :color_assignments, :name => :index_separacions_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    add_index :color_assignments, [:ord_trab_id]
  end
end
