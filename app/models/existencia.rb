class Existencia < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    cantidad :integer
    numfact :integer
    lote  :string
    serie :string
    existalto :decimal, :precision => 8, :scale => 2, :default => 0
    existancho :decimal, :precision => 8, :scale => 2, :default => 0
    codigo :string
    timestamps
  end

  belongs_to :bodega
  belongs_to :polimero
  belongs_to :unidad
  has_many :movimientos

  def name
  	self.polimero.tipomat.to_s + '_' + self.polimero.tipo.to_s + '__' + self.cantidad.to_s
	end

  def self.findex(polspec)
    self.find(:all, :joins => :polimero, :conditions => ["polimeros.tipomat = (?) AND polimeros.ancho > (?) AND polimeros.alto > (?) AND polimeros.espesor = (?)", polspec[0], polspec[1].to_f, polspec[2].to_f, polspec[3].to_s])
  end

  def self.finpol(pol,bod)
    self.find(:all, :conditions => ["polimero_id = (?) AND bodega_id = (?)", pol,bod])
  end

  def self.sumaex(pol,bod)
  	self.sum('cantidad', :conditions => ["polimero_id = (?) AND bodega_id = (?)", pol, bod])
  end

  def self.finduniq(polspec)
    self.find(:all, :joins => :polimero, :conditions => ["polimeros.tipomat = (?) AND polimeros.ancho > (?) AND polimeros.alto > (?) AND polimeros.espesor = (?) AND bodega_id = (?)", polspec[0], polspec[1].to_f, polspec[2].to_f, polspec[3].to_s, polspec[4].to_i], :group => 'polimero_id')
  end

  def self.countuniq(polspec)
    self.count(:all, :joins => :polimero, :conditions => ["polimeros.tipomat = (?) AND polimeros.ancho > (?) AND polimeros.alto > (?) AND polimeros.espesor = (?) AND bodega_id = (?)", polspec[0], polspec[1].to_f, polspec[2].to_f, polspec[3].to_s, polspec[4].to_i], :group => 'polimero_id')
  end

  def before_save
#    if self.cantidad
#      @qanti = self.cantidad
#      self.cantidad = 1
#      if @qanti > 1
#        creaneo(@qanti,self.attributes)
#      end
#    end
    unless self.existancho?
      self.existancho = self.polimero.ancho || 0
    end
    unless self.existalto?
      self.existalto = self.polimero.alto || 0
    end
  end

  def creaneo(cant,atribs)
    @veces = (cant.to_i - 1)
    @veces.times do
      @exis = Existencia.new(atribs)
      @exis.save
    end
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

