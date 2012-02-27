class HoboMigration55 < ActiveRecord::Migration
  def self.up
    add_column :ord_trabs, :mcGuiaapy, :string
    add_column :ord_trabs, :mcMPuntoapy, :string
    add_column :ord_trabs, :mcCrucesapy, :string
    add_column :ord_trabs, :mcTacasapy, :string
    add_column :ord_trabs, :mcTirasapy, :string
    add_column :ord_trabs, :mcExcesoapy, :string
    add_column :ord_trabs, :mcMarcasapy, :string
    add_column :ord_trabs, :mcPimpapy, :string

    add_column :tareas, :asignado_id, :integer

    add_index :tareas, [:asignado_id]
  end

  def self.down
    remove_column :ord_trabs, :mcGuiaapy
    remove_column :ord_trabs, :mcMPuntoapy
    remove_column :ord_trabs, :mcCrucesapy
    remove_column :ord_trabs, :mcTacasapy
    remove_column :ord_trabs, :mcTirasapy
    remove_column :ord_trabs, :mcExcesoapy
    remove_column :ord_trabs, :mcMarcasapy
    remove_column :ord_trabs, :mcPimpapy

    remove_column :tareas, :asignado_id

    remove_index :tareas, :name => :index_tareas_on_asignado_id rescue ActiveRecord::StatementInvalid
  end
end
