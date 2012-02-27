class HoboMigration1 < ActiveRecord::Migration
  def self.up
    create_table :productos do |t|
      t.string   :name
      t.string   :codTflex
      t.string   :codCliente
      t.decimal  :mdi_desarrollo
      t.decimal  :mdi_ancho
      t.string   :barcode
      t.string   :colorBarcode
      t.integer  :dispBandas
      t.decimal  :distTotalPerim
      t.decimal  :distorAncho
      t.decimal  :nPasos
      t.decimal  :nBandas
      t.integer  :colorUnion
      t.integer  :supRev
      t.text     :caractImp
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :users do |t|
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :name
      t.string   :email_address
      t.boolean  :administrator, :default => false
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "active"
      t.datetime :key_timestamp
    end
    add_index :users, [:state]
  end

  def self.down
    drop_table :productos
    drop_table :users
  end
end
