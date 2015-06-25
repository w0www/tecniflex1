class Listbarcode < ActiveRecord::Migration
  def self.up
    create_table :list_barcodes do |t|
      t.text     :description
      t.string   :code
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :ord_trabs, :list_barcode_id, :integer

    add_index :ord_trabs, [:list_barcode_id]
  end

  def self.down
    remove_column :ord_trabs, :list_barcode_id

    drop_table :list_barcodes

    remove_index :ord_trabs, :name => :index_ord_trabs_on_list_barcode_id rescue ActiveRecord::StatementInvalid
  end
end
