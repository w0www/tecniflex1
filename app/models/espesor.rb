class Espesor < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    calibre     :decimal, :precision => 3, :scale => 2, :name => true
    descripcion :text
    timestamps
  end

  default_scope :order => 'calibre'
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
