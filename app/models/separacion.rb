class Separacion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    color    :string, :name => :true
    position :integer
    anilox   :string
    lpi      :string
    area    :decimal
    alto    :decimal
    ancho   :decimal
    timestamps
  end

	belongs_to :ord_trab
  belongs_to :tipomat
  belongs_to :espesor
  has_many :movimientos


  acts_as_list :scope => :ord_trab

  validates_presence_of :color, :lpi, :anilox, :tipomat, :espesor, :if => :mtzomtje?

  def mtzomtje?
	(self.ord_trab.mtje ||  self.ord_trab.mtz) && self.ord_trab.activa?
  end

  def before_create
  	orden = self.ord_trab
  	unless orden.separacions.count <= 1
  		anterior = orden.separacions.last
  		self.lpi = anterior.lpi
  		self.tipomat = anterior.tipomat
  		self.espesor = anterior.espesor
  	end
	end

	#Para crear un nuevo item en input-many : <input-many template="&Locmathist.new(:field_tech => @current_user, :project => @current_project)">
  def areasep
	orden = self.ord_trab
    unless (alto == nil && ancho == nil)

	if orden.nCopias > 1
		@areasep = alto*ancho*orden.nCopias
	else
     		 @areasep=(alto*ancho)
	end

    else
	@areasep=0
   #   @orden=self.ord_trab
   #   unless (@orden.mdi_ancho == nil && @orden.mdi_desarrollo == nil)
 #       @areasep=(@orden.mdi_ancho*@orden.mdi_desarrollo)
  #    else
   #     @areasep = 0
   #   end
  #  self.area=@areasep
  #  self.save
    end
  end

def before_update
	self.area = self.areasep
end
  #def poliaptos(polspec)
   # Bodega.find(:all).repeat |bode|
   #   bode
  #end



  # --- Permissions --- #
  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
	 true
# acting_user.administrator? || acting_user.hace?("Grabado")
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
