  class Cilindro < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    nombre		   :string
    distorsion :decimal
    pctDistor   :decimal, :precision => 5, :scale => 3
    duplo      :string
    espesor    :decimal, :precision => 3, :scale => 2
    timestamps
  end

  validates_presence_of :nombre, :distorsion
  belongs_to :impresora
  has_many :ord_trabs


  def before_save
    self.pctDistor = (distorsion / name.to_f) * 100
  end

  def name
		self.nombre.to_s + '_' + self.distorsion.to_s
	end

  default_scope :order => 'nombre'

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

