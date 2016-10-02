class HoboMigration82 < ActiveRecord::Migration
  def self.up
    add_column :auditorias, :fecha, :datetime
    add_column :auditorias, :detalles, :string
    add_column :auditorias, :ord_trab_id, :integer
    add_column :auditorias, :user_id, :integer

    add_index :auditorias, [:ord_trab_id]
    add_index :auditorias, [:user_id]
  end

  def self.down
    remove_column :auditorias, :fecha
    remove_column :auditorias, :detalles
    remove_column :auditorias, :ord_trab_id
    remove_column :auditorias, :user_id

    remove_index :auditorias, :name => :index_auditorias_on_ord_trab_id rescue ActiveRecord::StatementInvalid
    remove_index :auditorias, :name => :index_auditorias_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
