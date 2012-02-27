class Bodega < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    nombre      :string, :name => true
    descripcion :text
    timestamps
  end

  has_many :movimientos
  has_many :existencias, :accessible => true
  has_many :polimeros, :through => :existencias



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

