class ListBarcode < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    description :text
    code        :string
    num_char    :integer
    timestamps
  end

  def name
    "#{self.code}"
  end


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
