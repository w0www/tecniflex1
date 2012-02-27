class HoboMigration85 < ActiveRecord::Migration
  def self.up
    add_column :curvas, :impresora_id, :integer

    add_index :curvas, [:impresora_id]
  end

  def self.down
    remove_column :curvas, :impresora_id

    remove_index :curvas, :name => :index_curvas_on_impresora_id rescue ActiveRecord::StatementInvalid
  end
end
