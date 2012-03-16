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
  
  validates_presence_of :color, :anilox, :tipomat, :espesor, :if => :activa?
  
  def activa?
    self.ord_trab.activa?
  end 
  def before_create
  	orden = self.ord_trab
  	unless orden.separacions.count <= 1
  		anterior = orden.separacions.last
  		self.lpi = anterior.lineatura
  		self.tipomat = anterior.tipomat
  		self.espesor = anterior.espesor
  	end
	end
	#Para crear un nuevo item en input-many : <input-many template="&Locmathist.new(:field_tech => @current_user, :project => @current_project)">
  def areasep
    unless (alto == nil && ancho == nil)
      @areasep=(alto*ancho)
    else
      @orden=self.ord_trab
      unless (@orden.mdi_ancho == nil && @orden.mdi_desarrollo == nil)
        @areasep=(@orden.mdi_ancho*@orden.mdi_desarrollo)
      else
        @areasep = 0
      end
    self.area=@areasep
    self.save
    end
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
    acting_user.administrator? || acting_user.hace?("Grabado")
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
