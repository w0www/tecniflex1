class Tarea < ActiveRecord::Base

  hobo_model # Don't put anything above this
  acts_as_list :scope => :recurso

  fields do
    instrucciones :text
    fechatope     :date
    timestamps
  end

  belongs_to :ord_trab
  belongs_to :proceso
  belongs_to :recurso
  belongs_to :asignado, :class_name => "User", :foreign_key => :asignada_a
  has_many :intervencions, :accessible => true, :dependent => :destroy
  has_many :users, :through => :intervencions

  def name
    self.ord_trab.numOT.to_s + '_' + self.proceso.nombre.to_s
  end
  
  def before_create
	if self.ord_trab.state == "habilitada"
		self.state = "habilitada"
	end
  end
	
  def aptos
    User.with_procesos(self.proceso)
  end
  
  def opciones
  	@opciones ||= self.aptos.map {|uapto| [uapto.name, uapto.id]}
	end
  
	
  def self.find_utiles(usuario)
    @cuser = usuario
    @uprocid = @cuser.procesos.*.id
    Tarea.activa.find(:all, :conditions => ["proceso_id IN (?) AND asignada_a IS (?)", @uprocid, nil])
  end
  
  def stvisto
    if (self.proceso.nombre.to_s == "Visto Bueno") || (self.proceso.nombre.to_s == "Printer")
      case self.state
        when "creada"
          "creado"
        when "habilitada"
          "habilitado"
        when "iniciada"
          "enviado"
        when "detenida"
          "observaciones"
        when "terminada"
          "aprobado"
        else
          "desconocido"
      end
    else
      self.state
    end
  end


  named_scope :activa, :conditions => ["state IN (?)", ["habilitada","detenida"]] # se elimina "iniciada" para evitar 2 operadores trabajando en la misma tarea.


  lifecycle do

		state :creada, :default => true

		state :habilitada, :iniciada, :detenida, :terminada

		create :crear, :become => :creada, :available_to => :all

		transition :habilitar, { :creada => :habilitada }, :available_to => :all, :unless => "(self.asignada_a == nil) && (self.proceso.grupoproc.asignar == true)"

		transition :iniciar, { :habilitada => :iniciada }, :available_to => :all 

		transition :detener, { :iniciada => :detenida }

		transition :terminar, { :iniciada => :terminada }, :available_to => :all

		end

  # --- Permissions --- #

  def create_permitted?
    acting_user.superv?
  end

  def update_permitted?
    acting_user.superv? || acting_user.hace?("Grabado")
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
  
  private
    def notificar
      email = RecibArchMailer.deliver_enviado(self.ord_trab.cliente, self.ord_trab.nomprod)
    end
    
end

