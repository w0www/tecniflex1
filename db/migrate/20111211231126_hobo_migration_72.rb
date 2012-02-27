class HoboMigration72 < ActiveRecord::Migration
  def self.up
    create_table :grupoprocs do |t|
      t.string   :nombre
      t.text     :descripcion
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :procesos, :grupoproc_id, :integer

    add_index :procesos, [:grupoproc_id]
  end

  def self.down
    remove_column :procesos, :grupoproc_id

    drop_table :grupoprocs

    remove_index :procesos, :name => :index_procesos_on_grupoproc_id rescue ActiveRecord::StatementInvalid
  end
end
