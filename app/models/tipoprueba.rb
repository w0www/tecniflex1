class Tipoprueba < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    nombre      :string, :name => :true
    descripcion :text
    timestamps
  end

	has_many :pruebas
	has_many :ord_trabs, :through => :pruebas

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
