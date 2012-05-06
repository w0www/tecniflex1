class HoboMigration64 < ActiveRecord::Migration
  def self.up
    drop_table :ordmailers
  end

  def self.down
    create_table "ordmailers", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
