class Recurso < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    nombre      :string, :name => :true
    descripcion :text
    velocidad   :integer
    unidad1     :string
    unidad2     :string
    tiempo      :integer
    indicador   :string
    timestamps
  end

  has_many :tareas, :order => :position
  belongs_to :proceso

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
