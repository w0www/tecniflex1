class MovHeader < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    factura       :integer
    fecha         :date
    proveedor     :string
    observaciones :text
    timestamps
  end

  has_many :movimientos, :accessible => true

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
