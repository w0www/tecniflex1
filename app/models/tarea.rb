class Tarea < ActiveRecord::Base

  hobo_model # Don't put anything above this
  #acts_as_list :scope => :recurso

  fields do
    instrucciones :text
    fechatope     :date
    ciclo					:integer
    timestamps
  end

  # Una tarea depende de un proceso y de una orden de trabajo.
  belongs_to :ord_trab
  belongs_to :proceso

  belongs_to :recurso
  belongs_to :asignado, :class_name => "User", :foreign_key => :asignada_a
  # Se elimina dependent => destroy, porque podría borrarse una tarea y perder el registro del trabajo de los operadores.
  has_many :intervencions, :accessible => true, :dependent => :destroy

  has_many :users, :through => :intervencions 
  def name
    self.ord_trab.numOT.to_s + '_' + self.proceso.nombre.to_s
  end

	named_scope :activa, :conditions => ["state IN (?)", ["habilitada","iniciada","detenida","enviada","recibida", "en_revision"]]
  named_scope :disp, :conditions => ["state IN (?)", ["habilitada","detenida","enviada","recibida", "en_revision"]]
  named_scope :detipo, lambda { |proce| { :conditions => ["proceso_id = ?", Proceso.find_by_nombre(proce).id] }}
  
  def after_create
  	self.ciclo ||= 1
		self.save
	end
  

	# Marcar las intervenciones pertenecientes a una tarea destruida, para que no aparezcan en la lista inicial.
	#def before_destroy
	#	self.intervencions.each do |estin|
	#		estin.final = true
	#		estin.save
	#	end
	#end

  def aptos
    User.with_procesos(self.proceso)
  end

  def opciones
  	@opciones ||= self.aptos.map {|uapto| [uapto.name, uapto.id]}
	end

	def activa?
    ['habilitada','iniciada','detenida','recibida','enviada', 'en_revision'].include?(self.state)
  end

  def activa_poli?
    ['habilitada','iniciada','detenida','recibida','enviada', 'en_revision'].include?(self.state)
  end

  def gp(grupo)
		self.proceso.grupoproc.send(grupo.to_sym)
	end

	def after_update
    if self.ord_trab != ""
      ordtars = self.ord_trab.sortars
    
		unless ordtars.*.state.index("creada") == nil
      if ["habilitada","iniciada"].include?(self.ord_trab.state)
				if ordtars[ordtars.*.state.index("creada").to_i] == ordtars.first
					if ordtars.first.asignada_a != nil
						ordtars.first.lifecycle.habilitar!(User.first)
					end
				#else
           # REVISAR LA CONDICION DE HABILITACION DE LAS TAREAS
					# Habilita la primera tarea que aparezca "creada"
					#if (ordtars[ordtars.*.state.index("creada").to_i].asignada_a != nil) && (ordtars[ordtars.*.state.index("creada").to_i-1].state = "terminada")
						ordtars[ordtars.*.state.index("creada").to_i].lifecycle.habilitar!(User.first)
					#end
				end
      end
		end
    end
	end
	
  def self.find_utiles(usuario)
    @cuser = usuario
    if @cuser.procesos != []
			@uprocid = @cuser.procesos.*.id
			Tarea.activa.find(:all, :conditions => {:proceso_id => @uprocid, :asignada_a => nil})
		else
			[]
		end
  end

  # Calcula el tiempo en minutos neto en realizarse una tarea
  def tneto 
    tne = 0
    for intervencion in self.intervencions
      dife = intervencion.termino ? (intervencion.termino - intervencion.inicio) / 60 : 0
      tne += dife
    end
    # Devolvemos 3.68 (integer)
    return tne.to_s.first(4).to_f
  end
  
  def proctar
    if self.proceso
      self.proceso.nombre
    else
      "Sin proceso"
    end
  end

	#named_scope :saevb, :conditions =>

  lifecycle do

		state :creada, :default => true

		state :habilitada, :iniciada, :detenida, :enviada, :cambiada, :recibida, :terminada, :reiniciada, :rechazada, :en_revision

		create :crear, :become => :creada, :available_to => :all

		transition :habilitar, { :creada => :habilitada }, :available_to => :all, :unless => "(self.asignada_a == nil) && (self.proceso.grupoproc.asignar == true)"

		transition :cambiar, { :enviada => :cambiada }, :available_to => :all, :if => "self.proceso.reiniciar" do
			estor = self.ord_trab.sortars
			estor[estor.index(self)-1].lifecycle.habilitar!(User.first) if estor[estor.index(self)-1]
		end

		transition :habilitar, { :cambiada => :habilitada }, :available_to => :all, :if => "self.proceso.reiniciar"

		##Agregar condición para rehabilitar toda la OT, a pedido de un supervisor.
		transition :habilitar, { :terminada => :habilitada }, :available_to => :all do
		  aumentaciclo
		end

		transition :habilitar, { :rechazada => :habilitada}, :available_to => :all do
			aumentaciclo
		end

		transition :iniciar, { :habilitada => :iniciada }, :available_to => :all do
			if self.ord_trab.state == "habilitada"
				self.ord_trab.lifecycle.iniciar!(User.first)
			end
		end

		###########
		## Idea: aumentar contadores al terminar tarea anterior, para todas excepto la primera
		## Crear método "volver_a(proceso)" que maneje el flujo y los estados de las tareas.
		############


    transition :enviar, { [:iniciada, :recibida, :habilitada] => :enviada }, :available_to => :all do
      RecibArchMailer.delay.deliver_enviado(self.ord_trab.cliente, self.ord_trab)
    end

    transition :enviar_pdf, { :iniciada => :en_revision }, :available_to => :all, :if => "self.proceso.nombre.downcase == 'vistobueno'"

		transition :terminar, { :recibida => :terminada }, :available_to => :all, :if => "self.proceso.nombre.downcase == 'vistobueno'" do
      logger.info "esto esto"
      if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
        self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1].lifecycle.habilitar!(User.first)
        self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1].lifecycle.iniciar!(User.first) 
      end
    end

		transition :recibir, { :enviada => :recibida }, :available_to => :all

		transition :reiniciar, { :recibida => :iniciada }, :available_to => :all do
			aumentaciclo
		end

		transition :reiniciar, { :detenida => :iniciada }, :available_to => :all

		transition :detener, { :iniciada => :detenida }, :available_to => :all


		transition :rechazar, { :iniciada => :rechazada }, :available_to => :all

		transition :rechazar, { :en_revision => :habilitada }, :available_to => :all

		transition :terminar, { :enviada => :terminada }, :available_to => :all do
      if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
				self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1].lifecycle.habilitar!(User.first) if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
      end
    end

		transition :terminar, { :iniciada => :terminada }, :available_to => :all do
			if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
      	self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1].lifecycle.habilitar!(User.first) if self.ord_trab.sortars[self.ord_trab.sortars.index(self)+1]
      end
    end

		transition :terminar, { :en_revision => :recibida }, :available_to => :all

		transition :eliminar, {:creada => :destroy}, :available_to => :all

    transition :eliminar, {:habilitada => :destroy}, :available_to => :all

    transition :eliminar, {:terminada => :destroy}, :available_to => :all

	end

	def interventor?
		if self.intervencions != []
			self.intervencions.*.user_id.include?(acting_user.id)
		else
			false
		end
	end

  # --- Permissions --- #

  def create_permitted?
    acting_user.superv?
  end

  def update_permitted?
    acting_user.superv? || self.proceso.edicion_medidas
  end

  def destroy_permitted?
    #~ acting_user.administrator?
    true
  end

  def view_permitted?(field)
    true
  end

  private
    def notificar
      email = RecibArchMailer.deliver_enviado(self.ord_trab.cliente, self.ord_trab.nomprod)
    end

		def aumentaciclo
			self.ciclo += 1
			self.save
		end
end

