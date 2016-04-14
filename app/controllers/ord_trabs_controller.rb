class OrdTrabsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  # , :except => :index


  def new
    if params[:id]
      # @prima es la OT original
      @prima = OrdTrab.find(params[:id])
      # @primat contiene los atributos de la OT original excepto 3
      @primat = @prima.attributes.except('numOT','numFact','numGuia')
      # @sepas es un array con las separaciones de la OT
      @sepas = []
      @prima.separacions.each do |sepa|
        @sepas << sepa.attributes.except(:ord_trab_id)
      end
      # @sepash es un hash con las separacion de la OT
      @sepash = {:separacions => @sepas}
      # @nueva_ot es una nueva OT con los atributos de la OT original + las separaciones
      @nueva_ot = OrdTrab.new(@primat.merge(@sepash))
      @nueva_ot.version ||= 1
      @nueva_ot.version += 1
      hobo_new (@nueva_ot) do
        this.attributes = params[:ord_trab] || {}
        hobo_ajax_response if request.xhr?
      end
    else
      hobo_new do
        this.attributes = params[:ord_trab] || {}
        hobo_ajax_response if request.xhr?
      end

    end
  end

  def edit
    hobo_show do
      this.attributes = params[:ord_trab] || {}
      hobo_ajax_response if request.xhr?
    end
  end

  show_action :mipag

  show_action :improt do
		@ord_trab = OrdTrab.find(params[:id])
	end

  def update
    params[:ord_trab][:fecha] = Date.strptime(params[:ord_trab][:fecha], '%d/%m/%Y') if params[:ord_trab][:fecha]
    # Parseamos el valor del datepicker
    parsear_datepicker
    hobo_update do 
      if valid?
        # Si el primer proceso de las tareas es polimero es que hemos marcado solo polimero y entonces necesitamos activarlo.
        this.sortars.first.lifecycle.habilitar!(current_user) if this.sortars.first.proceso.nombre.downcase == "polimero"
        # Si es todo valido vamos a crear el fichero XML del mismo
        confi = Configuration.find_by_key("export_to_xml")
        if confi && confi.value == true
          crear_fichero_xml if this.cliente.generar_xml
        end
      end
    end
  end

  def create
    params[:ord_trab][:fecha] = Date.strptime(params[:ord_trab][:fecha], '%d/%m/%Y') 
    # Parseamos el valor del datepicker
    parsear_datepicker
    hobo_create do 
      if valid?
        # Si el primer proceso de las tareas es polimero es que hemos marcado solo polimero y entonces necesitamos activarlo.
        this.sortars.first.lifecycle.habilitar!(current_user) if this.sortars.first.proceso.nombre.downcase == "polimero"
        # Si es todo valido vamos a crear el fichero XML del mismo
        confi = Configuration.find_by_key("export_to_xml")
        if confi && confi.value == true
          crear_fichero_xml if this.cliente.generar_xml
        end
      end
    end
  end

	def index
    inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
    final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time if params[:fecha_fin] && !params[:fecha_fin].blank?
    
    hobo_index OrdTrab.apply_scopes(
      :cliente_is => params[:cliente],
      :codCliente_contains => params[:codigo_cliente],
      :numOT_contains => params[:orden],
      :espesor_id_is => params[:espesor],
      :tipomat_id_is => params[:tipomat],
      :state_is => params[:estado],
      :proceso_is => [params[:proceso], params[:estado_proceso]],
      :created_between => [inicial, final]
    )
	end


  def show
   	# Guardamos en una variable si el usuario que esta viendo el show es un cliente o un operador
    @cliente_logeado = Cliente.find_by_correo(current_user.email_address)
    @usuario_polimero = current_user.email_address == "polimero@tecniflex.cl"
    @tipo_tarea_nueva = OrdTrab.find(params[:id]).tipoot_id == Tipoot.find_by_name("N (Trabajo Nuevo)").id

    if (@cliente_logeado || @usuario_polimero) && @tipo_tarea_nueva
      if params[:ord_trab] && params[:ord_trab][:nCopias] != ""
        @nueva_reposicion = OrdTrab.find(params[:id]).clone
        @nueva_reposicion.observaciones = params[:ord_trab][:observaciones]
        @nueva_reposicion.nCopias = params[:ord_trab][:nCopias]
        @nueva_reposicion.tipoot_id = Tipoot.find_by_name("R (REPOSICION)").id
        @nueva_reposicion.vb = false
        @nueva_reposicion.ptr = false
        @nueva_reposicion.mtz = false
        @nueva_reposicion.mtje = false
        @nueva_reposicion.pol = true
        @nueva_reposicion.fechaEntrega = calcular_fecha_reposicion
        @nueva_reposicion.save
        for s in OrdTrab.find(params[:id]).separacions
          separacion_nueva = s.clone
          # calcular numero de copias
          # si recibe algo se guarda ese
          if params[:ord_trab][:separacions][(s.position - 1).to_s]["nCopias"].blank?
            num_copias = s.nCopias
          else
            num_copias = params[:ord_trab][:separacions][(s.position - 1).to_s]["nCopias"]
          end          
          separacion_nueva.nCopias = num_copias unless num_copias.blank?
          @nueva_reposicion.separacions << separacion_nueva 
        end
      end

      if @nueva_reposicion && @nueva_reposicion.errors.count == 0
        @message = "Se ha creado una nueva reposición, click <a href='/ord_trabs/#{@nueva_reposicion.id}'><a href='/ord_trabs/#{@nueva_reposicion.id}'>AQUÍ</a> para verla."
        @nueva_reposicion.tareas.first.update_attribute(:state, "habilitada") if @nueva_reposicion.tareas != []
        # Enviar email al cliente
        RecibArchMailer.deliver_avisar_cliente(@nueva_reposicion,@nueva_reposicion.cliente.correo)
      elsif @nueva_reposicion && @nueva_reposicion.errors.count != 0
        @message = "Ha ocurrido un error, pongase en contacto con el administrador."
      end
    end
    hobo_show do |format|
      format.html { @taras = this.sortarasigs }
      format.xml {
        @ord_trab = OrdTrab.find(params[:id]) 
        stream = render_to_string(:template=>"ord_trabs/show" )
        send_data(stream, :type=>"text/xml",:filename => "#{@ord_trab.numOT}.xml")
      }
    end
  end

  def calcular_fecha_reposicion
    # Si es sabado
    if Time.zone.now.wday == 6
      # Si la hora pasa de las 12:00
      if (Time.zone.now + 6.hours).strftime("%H:%M") >= "12:00"
      # La hora de entrega es el lunes a la 13:00
        return "#{(Time.zone.now+2.days).year}-#{(Time.zone.now+2.days).month}-#{(Time.zone.now+2.days).day} 13:00".to_time
      # Si no la hora es la hora de creación + 6 horas
      else
        return Time.zone.now + 6.hours
      end
    elsif Time.zone.now.wday == 0
      # Si es domingo la hora de entrega es lunes a la 13:00
      return "#{(Time.zone.now+1.days).year}-#{(Time.zone.now+1.days).month}-#{(Time.zone.now+1.days).day} 13:00".to_time
    else
      # Si es cualquier otro dia de la semana la hora es + 6 horas despues de la hora de creacion
      return (Time.zone.now + 6.hours)
    end
  end

  def modificar
    hobo_new do
      @ot_anterior = OrdTrab.find (params[:id])
      OrdTrab.new(@ot_anterior)
    end
  end

  index_action :reposiciones do
    # Aquí solo pueden llegar los usuarios clientes y el polimero@tecniflex.cl
    @cliente_logeado = Cliente.find_by_correo(current_user.email_address)
    if @cliente_logeado || current_user.email_address == "polimero@tecniflex.cl"
      @hora_actual = DateTime.now.in_time_zone  
      @grupro = Grupoproc.tablero.order_by(:position)
      @procesos = Proceso.order_by(:position)
      @clies = Cliente.all
      @error = 0
      if @cliente_logeado
        params[:cliente] = @cliente_logeado
      end
      inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
      final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time.end_of_day if params[:fecha_fin] && !params[:fecha_fin].blank?
      codCliente = params[:codCliente].split("-").last unless params[:codCliente].blank?
      sigla = params[:codCliente].split("-").first unless params[:codCliente].blank?
      cliente = Cliente.find_by_sigla(sigla) unless sigla.blank?
      cliente_id = cliente.id unless cliente.blank?
      version = params[:version] unless params[:version].blank?
      tipo_ot = Tipoot.find_by_name("N (Trabajo Nuevo)").id

      @error = 1 if codCliente.blank? || cliente.blank?

      @todas = OrdTrab.apply_scopes(
        :cliente_id_is => cliente_id,
        :codCliente_is => codCliente,
        :version_is => version,
        :tipoot_id_is => tipo_ot
    )

    end
  end
  
  index_action :tablero do
    @hora_actual = DateTime.now.in_time_zone
    @grupro = Grupoproc.tablero.order_by(:position)
    @procesos = Proceso.order_by(:position)
#    @usuarios = User.find(:all, :order => :name)
    # si el usuario es un cliente solo mostrar las ord de ese cliente
    @cliente_logeado = Cliente.find_by_correo(current_user.email_address)
    @clies = Cliente.all
    @error = 0

    if @cliente_logeado
      params[:cliente] = @cliente_logeado
    end
    inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
    final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time.end_of_day if params[:fecha_fin] && !params[:fecha_fin].blank?
    codCliente = params[:codCliente].split("-").last unless params[:codCliente].blank?
    @todas = OrdTrab.apply_scopes(
      :cliente_is => params[:cliente],
      :codCliente_is => codCliente,
      :numOT_contains => params[:orden],
      :proceso_estado_is => [params[:estado_proceso]],
      :proceso_is => [params[:proceso]],
      :state_is => params[:estado],
      :created_between => [inicial, final]
    ).paginate(:page => params[:page], :per_page => 20)
    hobo_ajax_response if request.xhr?
  end


  index_action :tablerojax do
  @proces = Proceso.find(:all)
   if params[:startdate].blank? && params[:enddate].blank?
      @todas = OrdTrab.find(:all)
    else
      @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
      @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
      @todas = OrdTrab.find(:all,:conditions => ["created_at >= ? and created_at < ?",@from_date,@end_date])
    end
    hobo_ajax_response if request.xhr?
  end
 
  index_action :otscreadas do
    respond_to do |wants|
			wants.html do
          @otultsem = OrdTrab.paginate(:page => params[:page], :per_page => 35).group_by(&:cliente_id)
          @proces = Proceso.all.*.nombre
          if params[:cliente]
            @clies = params[:cliente]
            if (params[:startdate].blank? && params[:enddate].blank?)
              @otultsem = OrdTrab.paginate(:conditions => ["cliente_id = ?", @clies],:page => params[:page]).group_by(&:cliente_id)
            elsif params[:startdate]
              @clies = params[:cliente]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @otultsem = OrdTrab.paginate(:conditions => ["cliente_id = ? and created_at >= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone)],:page => params[:page]).group_by(&:cliente_id)
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otultsem = OrdTrab.paginate(:conditions => ["cliente_id = ? and created_at >= ? and created_at <= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)],:page => params[:page]).group_by(&:cliente_id)
              end
            elsif (params[:startdate].blank? && params[:enddate])
              @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
              @otultsem = OrdTrab.paginate(:conditions => ["cliente_id = ? and created_at <= ?", @clies, @fenal.to_datetime.in_time_zone(Time.zone)],:page => params[:page]).group_by(&:cliente_id)
            end 
          elsif params[:startdate]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @otultsem = OrdTrab.all(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otultsem = OrdTrab.all(:conditions => ["created_at >= ? and created_at <= ?", @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
              end
          elsif (params[:startdate].blank? && params[:enddate])
            @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
            @otultsem = OrdTrab.all(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
          end
      end
      wants.csv do
  #####
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          ##################
          @proces = Proceso.all.*.nombre
          @clies = params[:cliente] && params[:cliente].blank? ? "" : params[:cliente]
          @fechini = params[:startdate] && params[:startdate].blank? ? "" : Date.strptime(params[:startdate], "%d/%m/%Y")
          @fenal = params[:enddate] && params[:enddate].blank? ? "" : Date.strptime(params[:enddate], "%d/%m/%Y")
          
          if @clies != ""
            if @fenal.blank? && @fechini.blank?
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ?", @clies])
            elsif @fechini != "" && @fenal.blank?
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ?",
                       @clies, @fechini.to_datetime.in_time_zone(Time.zone)])            
            elsif @fechini.blank? && @fenal != ""
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at <= ?",
                       @clies, @fenal.to_datetime.in_time_zone(Time.zone)])
            elsif @fechini != "" && @fenal != ""
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ? and created_at <= ?",
                       @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
            end
          else
            if @fenal.blank? && @fechini.blank?
              @otsel = OrdTrab.all
            elsif @fechini != "" && @fenal.blank?
              @otsel = OrdTrab.all(:conditions => ["created_at >= ?",
                       @fechini.to_datetime.in_time_zone(Time.zone)])            
            elsif @fechini.blank? && @fenal != ""
              @otsel = OrdTrab.all(:conditions => ["created_at <= ?",
                       @fenal.to_datetime.in_time_zone(Time.zone)])
            elsif @fechini != "" && @fenal != ""
              @otsel = OrdTrab.all(:conditions => ["created_at >= ? and created_at <= ?",
                       @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
            end
          end

          ##################
          arre = ["CLIENTE", "NRO OT", "TIPO OT", "FECHA CREACION OT", "HORA CREACION OT", "FECHA ENTREGA", "HORA ENTREGA", "FECHA TERMINO", "HORA TERMINO", "PDF", "REVISION PDF", "PRINTER", "MATRICERIA", "MONTAJE", "REVISION", "POLIMERO", "DESPACHO", "AREA"]
          csv << arre
          ## data rows
            @otsel.each do |orden|
              tareas = orden.tareas
              # Cliente
              @elclie = orden.cliente ? orden.cliente : ""
              # NRO OT
              @numero_ot = orden.numOT
              # TIPO OT
              @tipo_ot = orden.tipoot
              # FECHA CREACION OT
              @fecha_creacion = orden.created_at.strftime("%d/%m/%Y %l:%M:%S") if orden.created_at
              # HORA CREACION OT
              @hora_creacion = orden.created_at.strftime("%l:%M:%S") if orden.created_at
              # FECHA ENTREGA
              @fecha_entrega = orden.fechaEntrega.strftime("%d/%m/%Y %l:%M:%S") if orden.fechaEntrega
              # HORA ENTREGA
              @hora_creacion = orden.fechaEntrega.strftime("%l:%M:%S") if orden.fechaEntrega
              # FECHA TERMINO OT
              # SI TODAS LAS TAREAS ESTAN TERMINADAS COGER LA ULTIMA TAREA SU ULTIMA INTERVENCION SU FECHA DE TERMINO
              if orden.orden_terminada
                if tareas != [] && tareas.last.intervencions != [] && tareas.last.intervencions.last.termino
                  @fecha_termino = tareas.last.intervencions.last.termino.strftime("%d/%m/%Y") 
                  @hora_termino = tareas.last.intervencions.last.termino.strftime("%l:%M:%S")
                end
              end
              tareas_tipo_vistobueno = tareas.detipo("VistoBueno")
              tareas_tipo_revisionvb = tareas.detipo("RevisionVB")
              tareas_tipo_printer = tareas.detipo("Printer")
              tareas_tipo_matriceria = tareas.detipo("Matriceria")
              tareas_tipo_montaje = tareas.detipo("Montaje")
              tareas_tipo_revisionmm = tareas.detipo("RevisionMM")
              tareas_tipo_polimero = tareas.detipo("Polimero")
              tareas_tipo_facturacion = tareas.detipo("Facturacion")
              # PROCESOS
              ## PDF
              @pdf = tareas_tipo_vistobueno != [] ? tareas_tipo_vistobueno.first.state : ""
              ## REVISION PDF
              @revision_pdf = tareas_tipo_revisionvb != [] ? tareas_tipo_revisionvb.first.state : ""
              ## PRINTER
              @printer = tareas_tipo_printer != [] ? tareas_tipo_printer.first.state : ""
              ## MATRICERIA
              @matriceria = tareas_tipo_matriceria != [] ? tareas_tipo_matriceria.first.state : ""
              ## MONTAJE
              @montaje = tareas_tipo_montaje != [] ? tareas_tipo_montaje.first.state : ""
              ## REVISION
              @revision = tareas_tipo_revisionmm != [] ? tareas_tipo_revisionmm.first.state : ""
              ## POLIMERO
              @polimero = tareas_tipo_polimero != [] ? tareas_tipo_polimero.first.state : ""
              ## DESPACHO
              @despacho = tareas_tipo_facturacion != [] ? tareas_tipo_facturacion.first.state : ""
              # AREA
              if orden.separacions
                @area = 0
                for o in orden.separacions
                  @area += o.area.to_f 
                end
              end
              arri = [@elclie, @numero_ot, @tipo_ot, @fecha_creacion, @hora_creacion, @fecha_entrega, @hora_entrega, @fecha_termino, @hora_termino, @pdf, @revision_pdf, @printer, @matriceria, @montaje, @revision, @polimero, @despacho, @area] 
              
              csv << arri
             end
          				
        # send it to da browsah
        end
        send_data(csv_string,
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Ordenes fact_al_%d_%m_%Y") + ".csv")
      end
    end
  #####      
  end 
  
  index_action :vbenvios do
    @grupro = Grupoproc.tablero.order_by(:position)
        @ctes = Cliente.all
          @todas = OrdTrab.paginate(:page => params[:page], :per_page => 35)
        if params[:cliente]
          @elcli = params[:cliente]
          
          if params[:codCliente] == "Cod. Cliente"
            @todas = OrdTrab.paginate( :conditions => ["cliente_id = ?", @elcli], :page => params[:page], :per_page => 35 )
          end
        elsif params[:startdate] && params[:enddate]
            @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
            @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
            @todas = OrdTrab.order_by(:id).paginate(:conditions => ["created_at >= ? and created_at <= ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone)],:page => params[:page], :per_page => 35)
        end
        hobo_ajax_response if request.xhr?
  end
  
    
  index_action :reporte do
  	@todas = OrdTrab.find(:all)

  @clies = Cliente.all
    if params[:orden].blank? && ((params[:startdate].blank? && params[:enddate].blank?) && (params[:cliente].blank? && params[:codCliente].blank?))
	    @todas = OrdTrab.all
	  elsif params[:orden]
      @orde = params[:orden]
      @todas = OrdTrab.all
      #hobo_index OrdTrab.apply_scopes(:search => [params[:orden], :numOT], :order_by => :numOT)
    elsif params[:cliente]
    	@elcli = params[:cliente]
    	@cocli = params[:codCliente]
    	if params[:codCliente] == "Cod. Cliente"
    		@todas = OrdTrab.find( :conditions => ["cliente_id = ?", @elcli])
    	else
    		@todas = OrdTrab.find( :conditions => ["codCliente = ? and cliente_id = ?", @cocli, @elcli])
    	end
    elsif params[:startdate] && params[:enddate]
        @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
        @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
        @todas = OrdTrab.order_by(:id).find(:conditions => ["created_at >= ? and created_at <= ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone)])
    end

  	respond_to do |wants|
			wants.html
			wants.csv do
				csv_string = CSV.generate(:col_sep => ";") do |csv|
					# header row
					csv << ["Cliente", "Codigo_Producto",  "O.T.", "N.Fact.", "Producto", "Proceso", "Usuario", "Fecha Inicio", "Hora Inicio", "Fecha Termino", "Hora Termino", "Colores", "cm2 tot.", "Observaciones"]
					# data rows
					@todas.each do |orden|
						if orden.tareas != []
							orden.tareas.each do |tara|
								if tara.intervencions != []
									tara.intervencions.each do |inte|
                    if inte.user != nil
                      if inte.termino 
                        termi = inte.termino
                      else
                        termi = Time.at(0)
                      end
                      if orden.cliente
                        codig = orden.cliente.sigla.to_s + orden.codCliente.to_s
                      else
                        codig = "" + orden.codCliente.to_s
                      end
                      colores = orden.separacions.*.color.join(", ")           
                      csv << [orden.cliente.name, codig,  orden.numOT, orden.numFact, orden.nomprod, tara.proceso.nombre, inte.user.name, inte.inicio.strftime("%d/%m/%y"), inte.inicio.strftime("%H:%M:%S"), termi.strftime("%d/%m/%y"), termi.strftime("%H:%M:%S"), colores, orden.areatot, inte.observaciones ]
                    end
									end
								end
							end
						end
					end
				end
				# send it to the browsah
				send_data(csv_string,
									:type => 'text/csv; charset=iso-8859-1; header=present',
									:disposition => "attachment", :filename => Time.now.strftime("Ordenes_al_%d_%m_%Y") + ".csv")
			end
		end
	end

  def do_eliminar
    do_transition_action :eliminar do
      redirect_to ord_trabs_path
    end
  end

  def habilitar
    transition_page_action :habilitar do
			flash[:notice] = "Habilitacion exitosa"
		end
  end

  def mail_ot
    @ot = OrdTrab.find(params[:id])
    email = render_to_string(:action => 'improt', :layout => false, :object => @ot)
    email = PDFKit.new(email)
    email.stylesheets << "#{Rails.root}/public/stylesheets/print.css"
    email = email.to_pdf
    RecibArchMailer.deliver_enviapdf(@ot,email)
    redirect_to :action => 'index'
	end

  private

  def crear_fichero_xml
    stream = render_to_string(:template=>"ord_trabs/show.xml")
    # Si el cliente es EMPACK Y COPACK se guarda en XML_IN-EMP_CPK
    carpeta = this.cliente.name == "COPACK" || this.cliente.name == "EMPACK" ? "XML_IN - EMP_CPK" : "XML_IN"
    f = open("#{Rails.root}/lib/nas/#{carpeta}/#{this.numOT}.xml", "wb")
    begin
      f.write(stream)
    ensure
      f.close()
    end
  end

  def parsear_datepicker
	if params[:ord_trab] && params[:ord_trab]["fechaEntrega"]
      fecha_entrega = Date.strptime params[:ord_trab]["fechaEntrega"], "%d/%m/%Y"
      params[:ord_trab]["fechaEntrega(1i)"] = fecha_entrega.year.to_s
      params[:ord_trab]["fechaEntrega(2i)"] = fecha_entrega.month.to_s
      params[:ord_trab]["fechaEntrega(3i)"] = fecha_entrega.day.to_s
    end
  end
end

