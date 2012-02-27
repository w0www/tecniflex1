class Curva < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    nombre      :string
    descripcion :text
    impresion enum_string(:'Superficie', :'Reverso')
    lineatura :string
    timestamps
  end

  belongs_to :tipomat
  belongs_to :espesor
  belongs_to :sustrato
  belongs_to :impresora
  has_many :ord_trabs
  has_many :curva_clientes
  has_many :clientes, :through => :curva_clientes, :accessible => true
  has_many :impresoras

  def name
    if self.espesor 
      self.tipomat.to_s + '_' + self.espesor.calibre.to_s + '_' + self.impresion.to_s + '_' + self.sustrato.to_s + '_' + self.lineatura.to_s
    end
  end
  
  def before_save
    self.nombre = name
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
