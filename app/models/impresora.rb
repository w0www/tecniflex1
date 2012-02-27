class Impresora < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    trapdefault :decimal
    bumpcurve   :string
    curva				:string
    timestamps
  end

  has_many :cilindros, :accessible => true
  has_many :ord_trabs
  has_many :aniloxes, :accessible => true
	belongs_to :cliente
	belongs_to :curva

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

