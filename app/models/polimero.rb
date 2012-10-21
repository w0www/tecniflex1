class Polimero < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    tipo enum_string(:'Convencional', :'Digital')
    nombre  :string
    alto    :integer
    ancho   :integer
    cantcaja:integer
    timestamps
  end

  def name
  	if self.espesor
    	self.tipomat.to_s + '_' + self.tipo.to_s + '_' + "%.2f" % self.espesor.calibre
    else
    	self.tipomat.to_s + '_' + self.tipo.to_s + '_'
    end
  end

  belongs_to :tipomat
  belongs_to :espesor
  has_many :movimientos
  has_many :existencias
  has_many :bodegas, :through => :existencias

  validates_presence_of :tipomat, :espesor

  def exisbod(bodega)
    @bode = bodega
    self.existencias.find(:all, :conditions => ["bodega_id = (?)", @bode])
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

