class HoboMigration20 < ActiveRecord::Migration
  def self.up
    add_column :impresoras, :curva, :string

    add_column :productos, :cilindro_id, :integer
    add_column :productos, :impresora_id, :integer

    add_index :productos, [:cilindro_id]
    add_index :productos, [:impresora_id]
  end

  def self.down
    remove_column :impresoras, :curva

    remove_column :productos, :cilindro_id
    remove_column :productos, :impresora_id

    remove_index :productos, :name => :index_productos_on_cilindro_id rescue ActiveRecord::StatementInvalid
    remove_index :productos, :name => :index_productos_on_impresora_id rescue ActiveRecord::StatementInvalid
  end
end
