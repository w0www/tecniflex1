class ChangeFechaEntregaDatetime < ActiveRecord::Migration
  def self.up
    change_column :ord_trabs, :fechaEntrega, :datetime
  end

  def self.down
    change_column :ord_trabs, :fechaEntrega, :date
  end
end
