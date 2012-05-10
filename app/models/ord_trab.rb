class OrdTrab < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    numOT         :integer, :name => :true
    numFact       :integer
    numGuia       :integer
    fecha         :date
    clase         :integer
    fechaEntrega  :date
    observaciones :text
    cfinal        :string
    visto         :boolean
    mtz           :boolean
    mtje          :boolean
    ptr           :boolean
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
    mcTacasH      :integer
    mcTacasV      :integer
    mcTacascol    :string
    mcTacasapy    :string
    mcTiras       :boolean
    mcTirascol    :string
    mcTirasapy    :string
    mcExceso      :boolean
    mcExcesoq     :integer
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
    mdi_desarrollo :decimal
    mdi_ancho      :decimal
    barcode        :string
    colorBarcode   :string
    dispBandas     :integer
    distTotalPerim :decimal
    distorAncho    :decimal
    nPasos         :decimal
    nBandas        :decimal
    nCopias        :integer
    colorUnion     :integer
    supRev enum_string(:'Superficie', :'Reverso')
    tipofotop enum_string(:'Digital', :'Convencional')
    trapping       :decimal
    prioridad enum_string(:'Normal', :'Repeticion', :'Urgencia')
    pctdistor      :decimal
    timestamps
  end

  has_many :pruebas
  has_many :tipopruebas, :through => :pruebas, :accessible => true
  has_many :separacions, :dependent => :destroy, :accessible => true, :order => :position
  has_many :procesos, :through => :tareas, :accessible => true
  has_many :tareas, :accessible => true, :dependent => :destroy
  belongs_to :encargado, :class_name => "User", :scope => {:rol_is => 'Supervisor' || 'Gerente'}
  belongs_to :curva

  belongs_to :cliente
  belongs_to :impresora
  belongs_to :cilindro
  belongs_to :tipomat
  belongs_to :espesor
  belongs_to  :sustrato

	default_scope :order => 'numOT DESC'

  def tarasigs
  @tarasi = true
  	self.tareas.each do |latask|
		    if latask.proceso.grupoproc.asignar && (latask.asignado == nil)
		        @tarasi = (@tarasi && false)
        end
    end
  @tarasi
	end


  lifecycle do

		state :creada, :default => true

		state :habilitada, :iniciada, :detenida, :terminada

		create :crear, :become => :creada, :available_to => "User.supervisores"

		transition :habilitar, { :creada => :habilitada }, :available_to => "User.supervisores", :if => "self.tarasigs" do
			self.sortars.first.lifecycle.habilitar!(acting_user) if self.sortars.first
    end

    transition :eliminar, { :habilitada => :destroy }, :available_to => "User.supervisores"

		transition :iniciar, { :habilitada => :iniciada }, :available_to => "User.supervisores"

		transition :reiniciar, { :detenida => :iniciada }, :available_to => "User.supervisores"

		transition :detener, { :iniciada => :detenida }, :available_to => "User.supervisores"

    transition :eliminar, { :iniciada => :destroy }, :available_to => "User.supervisores"

		transition :terminar, { :iniciada => :terminada }, :available_to => "User.supervisores" do
      self.tareas.each do |task|
          task.state = "terminada"
          task.save
      end
    end

    transition :reactivar, {:terminada => :habilitada}, :available_to => "User.supervisores"

	end

  validates_presence_of :mdi_desarrollo, :mdi_ancho, :barcode,  :if => "self.visto || self.ptr", :on => :habilitar
  validates_presence_of :trapping, :curva, :impresora, :cilindro, :nBandas, :nPasos, :nCopias, :sustrato, :fechaEntrega, :if => "(self.mtje || self.mtz) && (['habilitada','iniciada','detenida'].include?(self.state)) ", :on => :update
  validates_associated :separacions, :if => "(self.mtje || self.mtz) && self.activa? ", :on => :habilitar

  def before_create
		if OrdTrab.all == []
			self.numOT = 60000
		else
			self.numOT = (OrdTrab.order_by(:id).last.id.to_i || 0) + 60001
		end
		if OrdTrab.cliente_is(self.cliente) != []
			self.codCliente = (OrdTrab.order_by(:id).cliente_is(self.cliente).last.codTflex.to_i || 1) + 2000
		else
			self.codCliente = 2000
		end
  end

  def activa?
    ['habilitada','iniciada','detenida'].include?(self.state)
  end

  def after_update
  	# Hash para asignar usuarios a tareas segun su grupo de procesos
    @gptar = Hash.new
    self.tareas.asignada_a_is_not('nil').each do |tare|
      @gptar[tare.proceso.grupoproc.id.to_s] = tare.asignada_a.to_s
    end
    if @gptar != {}
     (self.tareas.all - self.tareas.asignada_a_is_not('nil')).each do |tare|
        tark = tare
        if tark.proceso.grupoproc.id == 9
          tark.asignada_a = @gptar['1']
        else
        tark.asignada_a = @gptar[tark.proceso.grupoproc.id]
        end
        tark.save
      end
    end
   end

  # Ordena las tareas de una OT segun la posicion de sus procesos. Permite habilitar las tareas en orden.
  def sortars
	estatars = self.tareas.map {|tar| [tar.id, tar.proceso.position]}
	estatarsort = estatars.sort_by{|item| item[1]}
	sortares = []
	estatarsort.each do |estata|
		sortares << Tarea.find(estata[0])
	end
	sortares
  end


  def before_save
    unless self.nBandas?
      self.nBandas = 1
    end
    unless self.nPasos?
      self.nPasos = 1
    end

    if self.visto
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

  end

  def after_save
    separacions.each {|sepa| sepa.areasep}
   # tareas.each do |tare|
   #   if tare.asignada_a

  end

  def validate
#    if (mdi_desarrollo*nPasos) > cilindro.desarr
#      errors.add(:mdi_desarrollo, "es insuficiente para el montaje" )
#    end
    unless valcol(self.mcGuiacol) == 0
        errors.add(:mcGuiacol, "se refiere a un color inexistente")
    end
    unless valcol(self.mcTacascol) == 0
        errors.add(:mcTacascol, "se refiere a un color inexistente")
    end
    unless valcol(self.mcPimpcol) == 0
        errors.add(:mcPimpcol, "se refiere a un color inexistente")
    end
#    @marcs = ["Guia","MPunto","Cruces","Tacas","Tiras","Exceso","Marcas","Pimp" ]
#    @marcs.each do |lamarc|
#      @mudcol = "valcol(self.mc#{lamarc}col)"
#      @mudapy = "valcol(self.mc#{lamarc}apy)"
#      unless self.send(@mudcol) == 0
#        errors.add(:mcGuiacol, "se refiere a un color inexistente")
#      end
#      unless self.send(@mudapy) == 0
#        errors.add(:mcGuiacol, "se refiere a un color inexistente")
#      end
#    end
  end

# Usado para asignar clases de acuerdo a la prioridad de la OT.
  def claset
    @valorc = "shower"
		if self.prioridad == "Urgencia"
			@valorc = "showerhi"
		elsif self.prioridad == "Sin_cobro"
			@valorc = "showerin"
    end
		@valorc
	end

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
	          	@usrs << inter.user.iniciales
	         	end
	        end
	      end
	    end
	  end
	  @usrs.uniq.join("-")
	end

	def estgrupro(grupro)
	  @gproc = Grupoproc.find_by_abreviacion(grupro)
	  @estag = ""
    @contcrea = 0
    @conthab = 0
    @contini = 0
    @contrei = 0
    @contenv = 0
    @contdet = 0
    @contter = 0
    @contrec = 0
    @cont = 0
    unless self.tareas == []
			self.tareas.each do |tare|
				if tare.proceso.grupoproc.abreviacion.to_s == @gproc.abreviacion.to_s
					case tare.state
						when "creada"
							@contcrea += 1
						when "habilitada"
							@conthab += 1
						when "iniciada"
							@contini += 1
						when "reiniciada"
							@contini += 1
						when "enviada"
							@contenv += 1
						when "recibida"
							@contrec += 1
						when "cambiada"
							@contrei += 1
						when "detenida"
							@contdet += 1
						when "terminada"
							@contter += 1
						else
							"desconocido"
					 end
					 @cont += 1
				 end

			 end
			 unless @cont == 0
					if @contdet >= 1
						@estag = "detenida"
					elsif @contini >= 1
						@estag = "iniciada"
					elsif @conthab >= 1
						@estag = "habilitada"
					elsif @contcrea >= 1
						@estag = "creada"
					elsif @contrec >= 1
						@estag = "recibido"
					elsif @contenv >= 1
						@estag = "enviado"
					elsif @contrei >= 1
						@estag = "cambios"
					elsif @contter >= 1
						@estag = "terminada"
					end
				else
					@estag = ""
				end
    end
     @estag
  end


#	  <% @todas.each do |tod| %>
#            <!-- <repeat with="&@todas"> -->
#              <% @tod = tod %>
#              <tr>
#                  <th style="width:70px;" class="#{@tod.state}" rowspan="2"><a with="&tod"><%=  tod.numOT -%></a></th><th rowspan="2" style="width: 12em;" class="#{@tod.state}"><%=  tod.nomprod -%></th>
#                  <%@ctr = 0%>
 #                 <% @grupro.each do |proce|%>
#                    <% unless @ctr == 1 %>
#                      <% tod.tareas.each do |tare| %>
#                            <% if tare.proceso.grupoproc.abreviacion.to_s == proce.abreviacion.to_s %>
#                              <td class="#{tare.state}" rowspan="2">
#                              <%= tare.stvisto -%><br/><%= tare.users.last -%>
#                              </td>
#                              <% @ctr += 1 %>
#                              <%next%>
#                            <%end%>
#                      <%end%>
#                      <% if @ctr == 0 %>
#                        <td rowspan="2"/>
#                      <% end %>
#                    <%end%>
#                    <% @ctr = 0 %>
#                  <% end %>



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
  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?  || acting_user.superv?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

