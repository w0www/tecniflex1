  class Cliente < ActiveRecord::Base
  hobo_model # Don't put anything above this

  fields do
    name      :string, :required 
    razsocial :string
    sigla     :string, :required 
    rut       :string
    correo    :email_address
    direccion :string
    telefono  :string
    fpago     :string
    tarifa		:decimal, :precision => 8, :scale => 2, :default => 0
    plazopago :string
    descuento :string
    timestamps
  end
  
  has_many :impresoras
  has_many :contactos, :accessible => true
  has_many :ord_trabs
  has_many :curva_clientes
  has_many :curvas, :through => :curva_clientes, :accessible => true

  default_scope :order => 'name'

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
