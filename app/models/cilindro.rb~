  class Cilindro < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name		   :string
    distorsion :decimal
    pctDistor   :decimal, :precision => 5, :scale => 3
    duplo      :string
    espesor    :decimal, :precision => 3, :scale => 2
    timestamps
  end

  validates_presence_of :name, :distorsion
  belongs_to :impresora
  has_many :ord_trabs
  
  default_scope :order => 'name'


  def before_save
    self.pctDistor = (distorsion / name.to_f) * 100
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

  def desarr
    self.name.to_f
  end


end

