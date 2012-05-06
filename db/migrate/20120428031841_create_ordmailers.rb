class CreateOrdmailers < ActiveRecord::Migration
  def self.up
    create_table :ordmailers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ordmailers
  end
end
