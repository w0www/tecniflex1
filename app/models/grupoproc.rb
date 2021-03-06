  class Grupoproc < ActiveRecord::Base

  hobo_model # Don't put anything above this
  acts_as_list

  fields do
    nombre      :string, :name => true
    abreviacion :string
    tablero     :boolean
    asignar     :boolean
    saevb				:boolean
    saemtz			:boolean
    saemtje			:boolean
    saeptr			:boolean
    saepol			:boolean
    descripcion :text
    timestamps
  end


  has_many :procesos

  default_scope :order => 'position'

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
