class Tinta < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    posicion :integer
    anilox   :string
    lpi      :string
    timestamps
  end
  
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
