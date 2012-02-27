class Prueba < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    aprob_int     :boolean
    aprob_cliente :boolean
    descripcion   :text
    timestamps
  end

	belongs_to :tipoprueba
	belongs_to :ord_trab

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
