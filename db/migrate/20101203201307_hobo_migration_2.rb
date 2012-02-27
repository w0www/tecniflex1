class HoboMigration2 < ActiveRecord::Migration
  def self.up
    create_table :ord_trabs do |t|
      t.integer  :numOT
      t.integer  :numFact
      t.date     :fecha
      t.integer  :clase
      t.integer  :fechaEntrega
      t.text     :observaciones
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :ord_trabs
  end
end
