class Tarea < ActiveRecord::Base

  hobo_model # Don't put anything above this
  acts_as_list :scope => :recurso

  fields do
    instrucciones :text
    fechatope     :date
    ciclovb					:integer
    cicloptr				:integer
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
  
  after_initialize :init
  
  def init
		self.ciclovb ||= 1
		self.cicloptr ||= 1
	end
	
  def before_create
 #  Usar index, maps y sort_by para encontrar la tarea siguiente de la OT, segun posicion (y habilitarla o no)
		estot = self.ord_trab
		if self == self.ord_trab.sortars.first
			if estot.state == "habilitada"
				self.state = "habilitada"
			end
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
    Tarea.activa.find(:all, :conditions => {:proceso_id => @uprocid, :asignada_a => nil})
  end


  named_scope :activa, :conditions => ["state IN (?)", ["habilitada","detenida","enviada","recibida"]] # se elimina "iniciada" para evitar 2 operadores trabajando en la misma tarea.


  lifecycle do

		state :creada, :default => true

		state :habilitada, :iniciada, :detenida, :enviada, :recibida, :terminada, :reiniciada

		create :crear, :become => :creada, :available_to => :all

		transition :habilitar, { :creada => :habilitada }, :available_to => :all, :unless => "(self.asignada_a == nil) && (self.proceso.grupoproc.asignar == true)"

		transition :cambiar, { :enviada => :reiniciada }, :available_to => :all, :if => "self.proceso.reinit" do
			self.ciclovb ||= 1
			self.cicloptr ||= 1
			self.save
			self.ciclovb += 1
			self.cicloptr += 1
			self.save
			self.ord_trab.sortars[self.ord_trab.sortars.index(self)-1].lifecycle.reiniciar!(acting_user) if self.ord_trab.sortars[self.ord_trab.sortars.index(self)-1]
		end
		
		transition :habilitar, { :reiniciada => :habilitada }, :available_to => :all, :if => "self.proceso.reinit"
		
		transition :iniciar, { :habilitada => :iniciada }, :available_to => :all 

		transition :enviar, { :iniciada => :enviada }, :available_to => :all, :if => "self.proceso.prueba" do
			RecibArchMailer.deliver_enviado(self.ord_trab.cliente, self.ord_trab)
		end
		
		transition :recibir, { :enviada => :recibida }, :available_to => :all, :if => "self.proceso.prueba"
		
		transition :reiniciar, { :recibida => :iniciada }, :available_to => :all, :if => "self.proceso.prueba" do		
			self.ciclovb ||= 1
			self.cicloptr ||= 1
			self.save
			if self.proceso.prueba 
				if self.proceso.reinit
					self.cicloptr += 1
					self.save
				else
					self.ciclovb += 1
					self.save
				end
					self.save
			end
		end
		
		transition :reiniciar, { :detenida => :iniciada }, :available_to => :all
	
		transition :detener, { :iniciada => :detenida }, :available_to => :all
		
		transition :terminar, { :enviada => :terminada }, :available_to => :all do
				self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1].lifecycle.habilitar!(acting_user) if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
		end

		transition :terminar, { :iniciada => :terminada }, :available_to => :all do
				self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1].lifecycle.habilitar!(acting_user) if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
		end
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

