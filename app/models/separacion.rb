class Separacion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    color    :string, :name => :true
    position :integer
    anilox   :string
    lpi      :string
    area    :decimal, :precision => 8, :scale => 2, :default => 0
    alto    :decimal, :precision => 8, :scale => 2, :default => 0
    ancho   :decimal, :precision => 8, :scale => 2, :default => 0
    nCopias :integer
    timestamps
  end

	belongs_to :ord_trab
  belongs_to :tipomat
  belongs_to :espesor
  has_many :movimientos


  acts_as_list :scope => :ord_trab

  validates_presence_of :color, :lpi, :anilox, :if => :mtzomtje?

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
      self.nCopias = orden.nCopias if self.nCopias.blank? || orden.tipoot_id != Tipoot.find_by_name("R (Reposicion)").id
  	end
	end

	#Para crear un nuevo item en input-many : <input-many template="&Locmathist.new(:field_tech => @current_user, :project => @current_project)">
  def areasep
	orden = self.ord_trab
    arease = 0
    unless (alto == nil && ancho == nil)
      if orden.nCopias != nil
        if orden.nCopias > 1
          arease = alto.to_f*ancho.to_f*orden.nCopias
        else
          arease = alto.to_f*ancho.to_f
        end
      else
        arease= alto.to_f*ancho.to_f
      end
    end
    arease
  end

def before_save
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
