class HoboMigration73 < ActiveRecord::Migration
  def self.up
    create_table :tipoots do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :ord_trabs, :tipoot_id, :integer

    add_index :ord_trabs, [:tipoot_id]
  end

  def self.down
    remove_column :ord_trabs, :tipoot_id
    add_column :ord_trabs, :prioridad, :string

    remove_index :ord_trabs, :name => :index_ord_trabs_on_tipoot_id rescue ActiveRecord::StatementInvalid
  end
end
