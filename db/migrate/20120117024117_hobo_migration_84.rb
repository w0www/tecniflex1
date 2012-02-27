class HoboMigration84 < ActiveRecord::Migration
  def self.up
    add_column :curvas, :lineatura, :string
    add_column :curvas, :sustrato_id, :integer
    remove_column :curvas, :sustrato

    add_index :curvas, [:sustrato_id]
  end

  def self.down
    remove_column :curvas, :lineatura
    remove_column :curvas, :sustrato_id
    add_column :curvas, :sustrato, :string

    remove_index :curvas, :name => :index_curvas_on_sustrato_id rescue ActiveRecord::StatementInvalid
  end
end
