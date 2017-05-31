class OrdTrab < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    numOT         :integer, :name => :true
    numFact       :integer
    numGuia       :integer
    fecha         :date
    clase         :integer
    fechaEntrega  :datetime
    observaciones :text
    cfinal        :string
		vb        		:boolean
    mtz           :boolean
    mtje          :boolean
    ptr           :boolean
    pol						:boolean
    mpFTP         :boolean
    mpFTPq        :integer
    mpFTPdev      :boolean
    mpPel         :boolean
    mpPelq        :integer
    mpPeldev      :boolean
    mpImp         :boolean
    mpImpq        :integer
    mpImpdev      :boolean
    mpMgr         :boolean
    mpMgrq        :integer
    mpMgrdev      :boolean
    mpOpt         :boolean
    mpOptq        :integer
    mpOptdev      :boolean
    mpPtr         :boolean
    mpPtrq        :integer
    mpPtrdev      :boolean
    mcGuia        :boolean
    mcGuiacol     :string
    mcGuiaapy     :string
    mcMPunto      :boolean
    mcMPuntocol   :string
    mcMPuntoapy   :string
    mcCruces      :boolean
    mcCrucescol   :string
    mcCrucesapy   :string
    mcTacas       :boolean
    mcTacasH      :decimal, :precision => 8, :scale => 2, :default => 0
    mcTacasV      :decimal, :precision => 8, :scale => 2, :default => 0
    mcTacascol    :string
    mcTacasapy    :string
    mcTiras       :boolean
    mcTirascol    :string
    mcTirasapy    :string
    mcExceso      :boolean
    mcExcesoq     :decimal, :precision => 8, :scale => 2, :default => 0
    mcExcesocol   :string
    mcExcesoapy   :string
    mcMarcas      :boolean
    mcMarcascol   :string
    mcMarcasapy   :string
    mcPimp        :boolean
    mcPimpcol     :string
    mcPimpapy     :string
    nomprod       :string
    codTflex      :string
    version				:integer
    codCliente     :string
    mdi_desarrollo :decimal, :precision => 8, :scale => 2, :default => 0
    mdi_ancho      :decimal, :precision => 8, :scale => 2, :default => 0
    barcode        :string
    barcodecopy    :string
    colorBarcode   :string
    dispBandas     :integer
    distTotalPerim :decimal, :precision => 8, :scale => 2, :default => 0
    distorAncho    :decimal, :precision => 8, :scale => 2, :default => 0
    nPasos         :decimal, :precision => 8, :scale => 2, :default => 0
    nBandas        :decimal, :precision => 8, :scale => 2, :default => 0
    nCopias        :integer
    colorUnion     :integer
    supRev enum_string(:' ', :'Superficie', :'Reverso')
    tipofotop enum_string(:'CDI', :'CDI DIGIFLOW', :'DOLEV', :'THERMOFLEX')
#    prioridad enum_string(:'N (Trabajo Nuevo)', :'M (Modificacion)', :'P (PostScript)', :'R (Reposicion)', :'S (Sin Costo)')
    trapping       :decimal, :precision => 8, :scale => 2, :default => 0
    urgente				:boolean
    pctdistor      :decimal, :precision => 8, :scale => 2, :default => 0
    color          :string
    fechafin      :date
    timestamps
  end

  has_many :pruebas
  has_many :tipopruebas, :through => :pruebas, :accessible => true
  has_many :separacions, :dependent => :destroy, :accessible => true, :order => :position

  # Una orden de trabajo tiene muchos procesos. (Tabla relacionada "TAREAS")
  has_many :procesos, :through => :tareas, :accessible => true
  has_many :tareas, :accessible => true, :dependent => :destroy, :autosave => true

  belongs_to :encargado, :class_name => "User", :scope => {:rol_is => 'Supervisor' || 'Gerente'}
  belongs_to :curva
  belongs_to :list_barcode
 # HABILITAR CONTACTO ASOCIADO A OT, ELEGIDO ENTRE CONTACTOS DEL CLIENTE (VER SCOPE)
  belongs_to :contacter, :class_name => "Contacto"

  belongs_to :tipoot
  belongs_to :cliente, :accessible => true
  belongs_to :impresora
  belongs_to :cilindro
  belongs_to :tipomat
  belongs_to :espesor
  belongs_to  :sustrato

  default_scope :order => 'numOT DESC'

  # Scope que busca las tareas que tienen el proceso y ese estado.
  named_scope :proceso_is, lambda { |proceso| { 
    :include => :tareas,
    :conditions => ["tareas.proceso_id = ?", Proceso.find_by_nombre(proceso).id] } }
  named_scope :proceso_estado_is, lambda {|estado| {
    :include => :tareas,
    :conditions => ["tareas.state = ?", estado] } 
  }

  # Scopes pantalla gerencial
  # NUEVAS
  named_scope :nuevas_hoy, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?",
    Tipoot.find_by_name("N (Trabajo Nuevo)"), Date.today]}}
  named_scope :nuevas_ayer, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?", 
    Tipoot.find_by_name("N (Trabajo Nuevo)"), Date.yesterday]}}
  named_scope :nuevas_semana, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("N (Trabajo Nuevo)"), Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]}}
  named_scope :nuevas_mes, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("N (Trabajo Nuevo)"), Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day]}}
  named_scope :nuevas_ano, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("N (Trabajo Nuevo)"), Date.today.beginning_of_year.beginning_of_day, Date.today.end_of_year.end_of_day]}}

  # MODIFICACION
  named_scope :modificacion_hoy, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?", 
    Tipoot.find_by_name("M (Modificacion)"), Date.today]}}
  named_scope :modificacion_ayer, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?", 
    Tipoot.find_by_name("M (Modificacion)"), Date.yesterday]}}
  named_scope :modificacion_semana, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("M (Modificacion)"), Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]}}
  named_scope :modificacion_mes, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("M (Modificacion)"), Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day]}}
  named_scope :modificacion_ano, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("M (Modificacion)"), Date.today.beginning_of_year.beginning_of_day, Date.today.end_of_year.end_of_day]}}

  # POSTSCRIPT
  named_scope :postscript_hoy, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?", 
    Tipoot.find_by_name("P (PostScript)"), Date.today]}}
  named_scope :postscript_ayer, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?", 
    Tipoot.find_by_name("P (PostScript)"), Date.yesterday]}}
  named_scope :postscript_semana, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("P (PostScript)"), Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]}}
  named_scope :postscript_mes, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("P (PostScript)"), Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day]}}
  named_scope :postscript_ano, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("P (PostScript)"), Date.today.beginning_of_year.beginning_of_day, Date.today.end_of_year.end_of_day]}}

  # REPOSICION
  named_scope :reposiciones_hoy, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?",
    Tipoot.find_by_name("R (Reposicion)"), Date.today]}}
  named_scope :reposiciones_ayer, lambda {{:conditions => ["tipoot_id = ? AND fechafin = ?", 
    Tipoot.find_by_name("R (Reposicion)"), Date.yesterday]}}
  named_scope :reposiciones_semana, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("R (Reposicion)"), Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]}}
  named_scope :reposiciones_mes, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("R (Reposicion)"), Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day]}}
  named_scope :reposiciones_ano, lambda {{:conditions => ["tipoot_id = ? AND fechafin BETWEEN ? AND ?",
    Tipoot.find_by_name("R (Reposicion)"), Date.today.beginning_of_year.beginning_of_day, Date.today.end_of_year.end_of_day]}}

  # TOTAL
  named_scope :total_hoy, lambda {{:conditions => ["fechafin = ?",
    Date.today]}}
  named_scope :total_ayer, lambda {{:conditions => ["fechafin = ?", 
    Date.yesterday]}}
  named_scope :total_semana, lambda {{:conditions => ["fechafin BETWEEN ? AND ?",
    Date.today.beginning_of_week.beginning_of_day, Date.today.end_of_week.end_of_day]}}
  named_scope :total_mes, lambda {{:conditions => ["fechafin BETWEEN ? AND ?",
    Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day]}}
  named_scope :total_ano, lambda {{:conditions => ["fechafin BETWEEN ? AND ?",
    Date.today.beginning_of_year.beginning_of_day, Date.today.end_of_year.end_of_day]}}

  # CREADAS
  named_scope :creadas_hoy, lambda {{:conditions => ["DATE(created_at) = ?",
    Date.today]}}

  def armacod
    armac = ""
    if self.cliente
      if self.cliente.sigla != ""
        armac = "#{self.cliente.sigla} - #{self.codCliente}"
      else
        if self.codCliente
          armac = self.codCliente
        else 
          armac = "OT #{self.numOT.to_s}" 
        end
      end
    else
      armac = "OT #{self.numOT.to_s}"
    end
    armac
  end

  def areatot
    atot = 0
    self.separacions.each do |lasepa|
      atot += lasepa.areasep
    end
    atot.to_i
  end
  
  # Crea un arreglo de arreglos de tipo [[Tarea1, ciclo1], [Tarea2, ciclo2]]
  def ciclos
    self.sortars.map { |tar| [tar.proceso.nombre, tar.ciclo]}
  end
    
    
  # Boolean para informar si estan asignadas todas las tareas cuyos procesos pertenecen a grupos de procesos asignables.
  def tarasigs
    tarasi = self.sortars.*.asignada_a.include?(nil) ? false : true
	end
	
	def alguna_asignada
    self.sortars.*.asignada_a.uniq.size == 1 && self.sortars.*.asignada_a.include?(nil) ? false : true
	end

# Asigna un codigo de producto (codCliente) a la orden de trabajo, correlativo desde la ultima para ese cliente
	def self.dacod(cli)
		if OrdTrab.all != [] && OrdTrab.cliente_is(cli) != [] && OrdTrab.order_by(:id).cliente_is(cli).last.codCliente != nil
			(OrdTrab.order_by(:id).cliente_is(cli).last.codCliente.to_i || 2000) + 1
		else
			2000
		end
 end

  # Metodos creados para usarlos en el XML (SE PUEDEN USAR EN MAS SITIOS)

  def codigo_producto
    texto = "#{self.cliente.sigla}"
    texto = "#{texto}-#{self.codCliente}" if self.codCliente
  end

  def mdi_desarrollo_xml
    if self.mdi_desarrollo.to_s.include?(".0") 
      return mdi_desarrollo.to_i.to_s
    else
      return mdi_desarrollo.to_s
    end
  end

  def mdi_ancho_xml
    if self.mdi_ancho.to_s.include?(".0")
      return mdi_ancho.to_i.to_s
    else
      return mdi_ancho.to_s
    end
  end

  def mcTacasH_xml
    if self.mcTacasH.to_s.include?(".0")
      return mcTacasH.to_i.to_s    
    else
      return mcTacasH.to_s
    end
  end

  def mcTacasV_xml
    if self.mcTacasV.to_s.include?(".0")
      return mcTacasV.to_i.to_s    
    else
      return mcTacasV.to_s
    end
  end

 # Permite volver a una tarea anterior, habilitandola
 def volver_a(procid,usuario)
 		esteprocid = Proceso.find(procid)
 		tares = self.tareas || []
 		if tares != []
			estata = tares.proceso_id_is(procid).first
			if Proceso.volver_desde_revision.include?(Proceso.find(procid)) || Proceso.rev.include?(Proceso.find(procid))
				estata.lifecycle.habilitar!(usuario)
			else
				nil
			end
      
		end
 end


  # Ordena las tareas de una OT segun la posicion de sus procesos. Permite habilitar las tareas en orden.
  def sortars
		estatars = Tarea.ord_trab_is(self).map {|tar| [tar.id, tar.proceso.position]}
		estatarsort = estatars.sort_by{|item| item[1]}
		sortares = []
		estatarsort.each do |estata|
			sortares << Tarea.find(estata[0])
		end
		sortares
  end

  def empty?
  	OrdTrab.all == []
  end

  lifecycle do

		state :creada, :default => true

		state :habilitada, :iniciada, :detenida, :terminada

		create :crear, :become => :creada, :available_to => "User.supervisores"

		transition :habilitar, { :creada => :habilitada }, :available_to => "User.supervisores", :if => "self.alguna_asignada"

   	transition :eliminar, { :habilitada => :destroy }, :available_to => "User.supervisores"

		transition :iniciar, { :habilitada => :iniciada }, :available_to => "User.supervisores"

		transition :reanudar, { :detenida => :iniciada }, :available_to => "User.supervisores"

		transition :detener, { :iniciada => :detenida }, :available_to => "User.supervisores"

    transition :eliminar, { :iniciada => :destroy }, :available_to => "User.supervisores"

		transition :terminar, { :iniciada => :terminada }, :available_to => "User.supervisores" do
      guardar_fechafin
    end

    transition :reactivar, {:terminada => :habilitada}, :available_to => "User.supervisores" do
    	esta = self
    	self.tareas.each do |tara|
    		if tara == esta.tareas.first
          tara.lifecycle.habilitar!(User.first)
    		else
    			tara.state = "creada"
    	  end
    		tara.save
    	end
    	self.tareas.first do |prima|
    		prima.state = "habilitada"
    		prima.save
    	end
    end

	end

  # VALIDACIONES
  # SUYCCOM HACK: COMENTAR CUANDO SE PUEDA QUE SON ESTAS VALIDACIONES YA QUE PARECE QUE SE REPITEN
  validates_presence_of :mdi_desarrollo, :mdi_ancho, :barcode,  :if => "self.vb || self.ptr", :on => :habilitar

  validates_presence_of :trapping, :curva, :impresora, :cilindro, :nCopias, :sustrato, :if => "(self.mtje || self.mtz) && (['habilitada','iniciada','detenida'].include?(self.state)) ", :on => :update
  validates_presence_of :cliente, :nomprod, :codCliente, :espesor, :supRev, :if => "self.pol && (['habilitada','iniciada','detenida'].include?(self.state)) ", :on => :update
  validates_presence_of :encargado_id
  validates_presence_of :dispBandas, :espesor, :tipomat, :if => "self.mtz"
  validates_associated :separacions, :if => "(self.mtje || self.mtz || self.pol) && self.activa? ", :on => :habilitar
  validates_presence_of :nBandas, :nPasos, :if => "(self.mtje || self.mtz) && (['habilitada','iniciada','detenida'].include?(self.state)) ", :on => :update


  validate :limite_codigo_barras, :barcodes_iguales, :pasosybandas, :espesores_iguales, :nrocopias, :validar_codigo_ean13, :validar_fecha_entrega

  def validar_fecha_entrega
    if self.fechaEntrega.strftime("%H:%M").to_s == "00:00" && self.tipoot_id == Tipoot.find_by_name("P (PostScript)").id
      errors.add(:fechaEntrega, "La fecha de entrega tiene que ser valida")
    end
  end

  def limite_codigo_barras
    if list_barcode
      errors.add(:barcode, "tiene que tener #{list_barcode.num_char} dígitos") if list_barcode.num_char && list_barcode.num_char > 0 && barcode.length != list_barcode.num_char
    end
  end

  def barcodes_iguales
    errors.add(:barcodecopy, "tiene que ser igual que el barcode") if !barcode.blank? && barcode != barcodecopy
  end

  def espesores_iguales
    if self.cilindro && self.espesor
      if self.mtz || self.mtje
        if self.espesor.calibre.to_f != self.cilindro.espesor.to_f
          errors.add(:espesor, "tiene que ser igual que el espesor del cilindro ") 
          errors.add(:cilindro, "tiene que ser igual que el espesor")
        end
      end
    end
  end

  def pasosybandas
    if self.mtz || self.mtje
      errors.add(:nPasos, "El número de pasos tiene que ser mayor que 0")  if self.nPasos.nil? || self.nPasos < 1 
      errors.add(:nBandas, "El número de bandas tiene que ser mayor que 0") if self.nBandas.nil? || self.nBandas < 1
      errors.add(:nCopias, "El número de copias tiene que ser mayor que 0") if self.nCopias.nil? ||  self.nCopias < 1
    end
  end

  def nrocopias
    if self.tipoot_id == Tipoot.find_by_name("R (Reposicion)").id && (self.mtz || self.mtje || self.pol)
      if self.nCopias.nil? || self.nCopias <= 0 || self.nCopias > 10
        errors.add(:nCopias,"El número de copias tiene que estar entre 1 y 10")
      end
    end
  end

  def validar_codigo_ean13
    if self.list_barcode
      if self.list_barcode.code == "EAN-13"
        suma = 0
        (0..11).each do |i|
          suma += ((i+1) % 2) == 0 ? self.barcode[i..i].to_i * 3 : self.barcode[i..i].to_i
        end
        # size == 13
        unless 10 - (suma % 10) == self.barcode[12..12].to_i || suma % 10 == 0
         digito = 10 - (suma % 10)
         errors.add(:barcode, "el dígito de control es erroneo y debería de ser #{digito}")
        end
      end
    end
  end


  def before_create
		if OrdTrab.all == []
			self.numOT = 60000
		else
			self.numOT = (OrdTrab.order_by(:id).last.id.to_i || 0) + 60001
		end

  end

  def activa?
    ['habilitada','iniciada','detenida'].include?(self.state)
  end


	# Boolean que indica si todas las tareas estn terminadas o la orden no tiene
	def tareas_terminadas?
    if self.tareas.blank?
      false
    else
      self.tareas.*.state.rindex{|x| x!="terminada"} == nil ? true : false
		end
	end

	# Elimina tareas que no correspondan a lo seleccionado en la OT. Debe ser ejecutado antes de save
	def kiltar(saejec)
		saegp = "sae" + saejec.to_s
			unless self.send(saejec)
				self.tareas.each do |estata|
					if estata.gp(saegp)
						estata.mark_for_destruction
					end
				end
			end
	end

  def before_update
    Auditoria.create(
      :tipo => "modificación", :fecha => DateTime.now, :user_id => acting_user.id, :ord_trab_id => self.id, :detalles => "#{self.inspect}"
    )
  end

  def after_update
    # Habilita la primera tarea al activarse la OT.
    estot = self
    ordtars = estot.sortars
    unless ordtars.*.state.index("creada") == nil
      if ordtars[ordtars.*.state.index("creada").to_i] == ordtars.first
        ordtars.first.lifecycle.habilitar!(User.first) if ordtars.first.asignada_a != nil
      else
        # Habilita la primera tarea que aparezca "creada"
        ordtars[ordtars.*.state.index("creada").to_i].lifecycle.habilitar!(User.first) if (ordtars[ordtars.*.state.index("creada").to_i].asignada_a != nil) && (ordtars[ordtars.*.state.index("creada").to_i-1].state == "terminada")
      end
    end

    @gptar = Hash.new
    self.tareas.asignada_a_is_not('nil').each do |tare|
      @gptar[tare.proceso.grupoproc.id.to_s] = tare.asignada_a.to_s
    end
    if @gptar != {}
      (self.tareas.all - self.tareas.asignada_a_is_not('nil')).each do |tark|
        if tark.proceso.grupoproc.id == 9
          tark.asignada_a = @gptar['1']
        else
          tark.asignada_a = @gptar[tark.proceso.grupoproc.id]
        end
        tark.save
      end
    end
  end

  def after_create
    usuario = acting_user.id if acting_user
    Auditoria.create(:tipo => "creación",:fecha => DateTime.now,:user_id => usuario, :ord_trab_id => self.id, :detalles => "#{self.inspect}" )
  end

  def before_destroy
    Auditoria.create(
      :tipo => "eliminación", :fecha => DateTime.now, :user_id => acting_user.id, :ord_trab_id => self.id, :detalles => "#{self.inspect}"
    )
  end


  def calcular_color_tablero(orden)
    # Si las tareas estan terminadas tenemos que calcular y guardar el color en base de datos
    # Si las tareas no estan terminadas solo tenemos que calcular el color
    fecha_entrega = orden.fechaEntrega
    hora_actual = DateTime.now.in_time_zone
#    tiempo_total_minute = hora_actual + orden.tiempo_total
    if fecha_entrega
      # SI FALTA UNA HORA PARA LA FECHA DE ENTREGA
      if fecha_entrega - 1.hour <= hora_actual && fecha_entrega > hora_actual
        color_tablero = 'lightyellow'
      # SI FALTA MAS DE UNA HORA PARA LA FECHA DE ENTREGA
      elsif fecha_entrega - 1.hour > hora_actual
        color_tablero = 'lightgreen'
      # SI HA PASADO LA FECHA DE ENTREGA
      elsif fecha_entrega <= hora_actual
        color_tablero = 'red'
      end
    else
      color_tablero = ''
    end
    return color_tablero
  end

  def tnetot
    timot = Time.at(0)
    self.tareas.each do |latar|
      timot += latar.tneto
    end
    timot
  end

  def tiempo_total
    tiempo = 0
    self.procesos.each do |proceso|
      tiempo += proceso.minutos_minimo if proceso.minutos_minimo
    end
    return tiempo
  end


  def orden_terminada
    comodin = true
    self.tareas.each do |tarea|
      if tarea.activa?
        comodin = false
      end
    end
    return comodin
  end
  

	def sortarasigs
		taras = self.tareas.find(:all, :conditions => ["proceso_id IN (?)", Proceso.asignables])
		estatars = taras.map {|tar| [tar.id, tar.proceso.position]}
		estatarsort = estatars.sort_by{|item| item[1]}
		sortares = []
			estatarsort.each do |estata|
				sortares << Tarea.find(estata[0])
			end
		sortares
  end

  def before_save
		sarr = ["vb", "ptr", "mtz", "mtje"]
		sarr.each do |saejec|
			tes = saejec + "_changed?"
			if self.send(tes.to_sym)
				kiltar(saejec)
			end
		end
		if self.vb
      unless self.procesos.*.grupoproc.*.saevb.include?(true)
      	Proceso.checkproc('saevb').each do |provisto|
          self.procesos << provisto
        end
      end
    end
    if self.mtz
      unless self.procesos.*.grupoproc.*.saemtz.include?(true)
        Proceso.checkproc('saemtz').each do |promtz|
          self.procesos << promtz
        end
      end
    end
    if self.ptr
      unless self.procesos.*.grupoproc.*.saeptr.include?(true)
       Proceso.checkproc('saeptr').each do |proptr|
          self.procesos << proptr
        end
      end
    end
    if self.mtje
      unless self.procesos.*.grupoproc.*.saemtje.include?(true)
        Proceso.checkproc('saemtje').each do |promtje|
          self.procesos << promtje
       	end
      end
    end
    if self.pol
      unless self.procesos.*.grupoproc.*.saepol.include?(true)
        Proceso.checkproc('saepol').each do |propol|
          self.procesos << propol
       	end
      end
    end
  end

  def validate
    unless valcol(self.mcGuiacol) == 0
        errors.add(:mcGuiacol, "se refiere a un color inexistente")
    end
    unless valcol(self.mcTacascol) == 0
        errors.add(:mcTacascol, "se refiere a un color inexistente")
    end
    unless valcol(self.mcPimpcol) == 0
        errors.add(:mcPimpcol, "se refiere a un color inexistente")
    end
  end

# Usado para asignar clases de acuerdo a la tipo de la OT.
  def claset
    @valorc = "shower"
		if self.tipoot && self.tipoot.name == "S (Sin Costo)"
			@valorc = "showerin"
    end
    if self.urgente
      @valorc = "showerhi"
    end
		@valorc
	end

  def urgclass
    if self.urgente
      "Urgencia"
    end
  end
  

	#Se usa para mostrar los usuarios asignados o involucrados con una tarea en el tablero
	def usersgp(grupro)
	  @gproc = Grupoproc.find_by_abreviacion(grupro)
	  @usrs = []
    unless self.tareas == []
      self.tareas.each do |tare|
	      if tare.proceso.grupoproc.abreviacion.to_s == @gproc.abreviacion.to_s
	      	if tare.asignado
	      		@usrs << ('*' + tare.asignado.iniciales.to_s)
	        end
	        if tare.intervencions
	        	tare.intervencions.each do |inter|
				if inter.user
	          			@usrs << inter.user.iniciales
				end
	         	end
	        end
	      end
	    end
	  end
	  @usrs.uniq.join("-")
	end

	#Entrega el estado de un grupo de procesos (para determinar el color de la celda en el trablero)
	def estgrupro(grupro)
	  @gproc = Grupoproc.find_by_abreviacion(grupro)
	  @estag = []
    @contcrea = 0
    @conthab = 0
    @contini = 0
    @contrei = 0
    @contenv = 0
    @contdet = 0
    @contter = 0
    @contrej = 0
    @contrec = 0
    @cont = 0
    @conthash = {}
    unless self.tareas == []
			self.tareas.each do |tare|
				if tare.proceso.grupoproc.abreviacion.to_s == @gproc.abreviacion.to_s
					case tare.state
						when "creada"
							@contcrea += 1
							@conthash["creada"]=tare.proceso.nombre
						when "habilitada"
							@conthab += 1
							@conthash["habilitada"]=tare.proceso.nombre
						when "iniciada"
							@contini += 1
							@conthash["iniciada"]=tare.proceso.nombre
						when "reiniciada"
							@contini += 1
							@conthash["iniciada"]=tare.proceso.nombre
						when "enviada"
							@contenv += 1
							@conthash["enviada"]=tare.proceso.nombre
						when "recibida"
							@contrec += 1
							@conthash["recibida"]=tare.proceso.nombre
						when "cambiada"
							@contrei += 1
							@conthash["cambiada"]=tare.proceso.nombre
						when "detenida"
							@contdet += 1
							@conthash["detenida"]=tare.proceso.nombre
						when "rechazada"
							@contrej += 1
							@conthash["rechazada"]=tare.proceso.nombre
						when "terminada"
							@contter += 1
							@conthash["terminada"]=tare.proceso.nombre
						else
							"desconocido"
					 end
					 @cont += 1
				 end

			 end
			 unless @cont == 0
					if @contdet >= 1
						@estag << @conthash["detenida"]
						@estag << "detenida"
					elsif @contrej >= 1
						@estag << @conthash["rechazada"]
						@estag << "rechazada"
					elsif @contini >= 1
						@estag << @conthash["iniciada"]
						@estag << "iniciada"
					elsif @conthab >= 1
						@estag << @conthash["habilitada"]
						@estag << "habilitada"
					elsif @contcrea >= 1
						@estag << @conthash["creada"]
						@estag << "creada"
					elsif @contrec >= 1
						@estag << @conthash["recibida"]
						@estag << "recibido"
					elsif @contenv >= 1
						@estag << @conthash["enviada"]
						@estag << "enviado"
					elsif @contrei >= 1
						@estag << @conthash["cambios"]
						@estag << "cambios"
					elsif @contter >= 1
						@estag << @conthash["terminada"]
						@estag << "terminada"
					end
				else
					@estag << ""
				end
    end
     @estag
  end

	def valcol(listacol)
    @valor = 0
    @colarr = listacol.split(',')
    unless @colarr.blank?
      @colarr.each do |col|
        unless col.to_i <= self.separacions.count
          @valor += 1
        end
      end
    end
    @valor
  end


  def areamat(sep)
    @areamat = (sep.alto*sep.ancho)
  end

  def tipos
    @sepas = []
    @mats = []
    if self.separacions != []
      @sepas = self.separacions
      if @sepas.first.tipomat != nil
        @mats << @sepas.first.tipomat
        @sepas.each do |sepa|
          unless @mats.include?(sepa.tipomat)
            @mats << sepa.tipomat
          end
        end
      end
    end
    @mats
  end

  def consumo(mat)
    unless self.separacions == nil
      @sepas = self.separacions
      @cons = 0
      @sepas.each do |sepa|
        if sepa.tipomat == mat
          @cons += sepa.area
        end
      end
      @cons
    else
      @cons = 0
    end
  end
  
  def guardar_fechafin
    self.fechafin = Date.today
    self.save
  end
  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? || Cliente.find_by_correo(acting_user.email_address)
  end

  def update_permitted?
    acting_user.administrator?  || acting_user.superv? || acting_user.facturador?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

