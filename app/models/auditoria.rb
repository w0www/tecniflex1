class Auditoria < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    tipo   :string
    fecha :datetime
    detalles :text
    timestamps
  end

  belongs_to :ord_trab
  belongs_to :user
  


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
