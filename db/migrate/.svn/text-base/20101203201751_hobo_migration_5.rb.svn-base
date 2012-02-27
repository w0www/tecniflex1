class HoboMigration5 < ActiveRecord::Migration
  def self.up
    create_table :cilindros do |t|
      t.string   :diametro
      t.decimal  :distorsion
      t.decimal  :pctDistor
      t.string   :anilox
      t.string   :lineatura
      t.string   :duplo
      t.decimal  :espesor
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :cilindros
  end
end
