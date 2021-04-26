	class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    rol	enum_string(:Operador, :Supervisor, :Supervisor2, :Grabador, :Gerente, :Facturador)
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    iniciales     :string, :unique
    tablero       :boolean, :default => false
    gerencial       :boolean, :default => false
    panel_supervisor       :boolean, :default => false
		fecha_actualizacion_password :date
    timestamps
  end

	has_many :intervencions
  has_many :tareas, :through => :intervencions
  has_many :asignacions, :class_name => "Tarea", :foreign_key => "asignada_a"
  has_many :procesos, :through => :user_labors, :accessible => true
  has_many :user_labors

  # This gives admin rights to the first sign-up.
  # Just remove it if you don't want that
  # before_create { |user| user.administrator = true if !Rails.env.test? && count == 0 }

	before_create { |user| user.fecha_actualizacion_password = Date.today }



  #named_scope :administrators, lambda {|acting_user| {:conditions => {acting_user.administrator?} }}

  def int_tiempo_total(estado,rechazada)
    tiempo = 0
    rechazada = rechazada == "false" ? "IS NULL" : "IS NOT NULL"
    for i in self.intervencions.find(:all, :conditions => ["DAY(#{estado}) = ? AND MONTH(#{estado}) = ? AND YEAR(#{estado}) = ? AND rechazada #{rechazada}", Date.today.day, Date.today.month, Date.today.year])
      dife = i.termino ? (i.termino - i.inicio) / 3600 : 0
      tiempo += dife
    end
    # Devolvemos 3.68 horas (integer)
    dia = tiempo.to_s.first(4).to_f
    tiempo = 0
    for i in self.intervencions.find(:all, :conditions => ["WEEK(#{estado}) = ? AND rechazada #{rechazada}", Date.today.strftime("%U")])
      dife = i.termino ? (i.termino - i.inicio) / 3600 : 0
      tiempo += dife
    end
    semana = tiempo.to_s.first(4).to_f
    tiempo = 0
    for i in self.intervencions.find(:all, :conditions => ["MONTH(#{estado}) = ? AND rechazada #{rechazada}", Date.today.month])
      dife = i.termino ? (i.termino - i.inicio) / 3600 : 0
      tiempo += dife
    end
    mes = tiempo.to_s.first(4).to_f
    return "#{dia} / #{semana} / #{mes}"
  end


  def int_totales(estado,rechazada)
    rechazada = rechazada == "false" ? "IS NULL" : "IS NOT NULL"
    dia = self.intervencions.find(:all, :conditions => ["DAY(#{estado}) = ? AND MONTH(#{estado}) = ? AND YEAR(#{estado}) = ? AND rechazada #{rechazada}", Date.today.day, Date.today.month, Date.today.year]).count
    semana = self.intervencions.find(:all, :conditions => ["WEEK(#{estado}) = ? AND rechazada #{rechazada}", Date.today.strftime("%U")]).count
    mes = self.intervencions.find(:all, :conditions => ["MONTH(#{estado}) = ? AND rechazada #{rechazada}", Date.today.month]).count
    return "#{dia} / #{semana} / #{mes}"
  end

  def int_tipo(dia,estado,proceso)
    self.intervencions.find(:all, :joins => [:tarea],
      :conditions => ["DAY(#{dia}) = ? AND MONTH(#{dia}) = ? AND YEAR(#{dia}) = ? AND tareas.proceso_id = ? AND tareas.state = ?",
                      Date.today.day, Date.today.month, Date.today.year, proceso, estado]).count
  end

	def facturador?
		self.rol == "Facturador"
	end


   def self.admines
    User.find(:all, :conditions => {:administrator => true})
  end

  def self.supervisores
		User.rol_is("Supervisor")
	end

  def self.supervisores2
    User.rol_is("Supervisor2")
  end

  def nombre
    return self.name
  end

  # Entrega un arreglo de arreglos de intervenciones por usuario, que incluyen el numero de tarea, el nombre del proceso, la fecha de inicio y la fecha de termino
  #def intertars
    #@estuser = self
    #self.intervencions.map { |latin| [@estuser.name, latin.estaot, latin.inteproc, latin.inicio, latin.termino]}
    # self.tareas(:order => :ord_trab_id)
  #end

  # --- Signup lifecycle --- #

  lifecycle do

    state :active, :default => true

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.deliver_forgot_password(self, lifecycle.key)
    end

    transition :reset_password, { :active => :active }, :available_to => :all,
               :params => [ :password, :password_confirmation ]

  end

  def superv?
    self.rol == "Supervisor"
  end

  def hace?(proce)
    self.procesos.*.nombre.include?(proce)
  end

  def sinfin
		self.intervencions.all(:conditions => {:termino => nil, :final => false})
	end




  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
