class HoboMigration6 < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      t.string   :name
      t.string   :razsocial
      t.string   :rut
      t.string   :direccion
      t.string   :telefono
      t.string   :fpago
      t.string   :plazopago
      t.string   :descuento
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :clientes
  end
end
