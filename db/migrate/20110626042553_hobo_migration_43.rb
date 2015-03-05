class HoboMigration43 < ActiveRecord::Migration
  def self.up
    drop_table :colors

    add_column :color_assignments, :color, :string
    add_column :color_assignments, :tipomat, :string
    add_column :color_assignments, :grosor, :string
    remove_column :color_assignments, :color_id

    remove_column :tintas, :color_id

    remove_index :color_assignments, :name => :index_color_assignments_on_color_id rescue ActiveRecord::StatementInvalid

    remove_index :tintas, :name => :index_tintas_on_color_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :color_assignments, :color
    remove_column :color_assignments, :tipomat
    remove_column :color_assignments, :grosor
    add_column :color_assignments, :color_id, :integer

    add_column :tintas, :color_id, :integer

    create_table "colors", :force => true do |t|
      t.string   "name"
      t.text     "descripcion"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :color_assignments, [:color_id]

    add_index :tintas, [:color_id]
  end
end
