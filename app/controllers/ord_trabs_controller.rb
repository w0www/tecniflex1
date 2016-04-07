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
    hobo_show do |format|
      format.html { @taras = this.sortarasigs }
      format.xml {
        @ord_trab = OrdTrab.find(params[:id]) 
        stream = render_to_string(:template=>"ord_trabs/show" )
        send_data(stream, :type=>"text/xml",:filename => "#{@ord_trab.numOT}.xml")
      }
    end
  end

  def modificar
    hobo_new do
      @ot_anterior = OrdTrab.find (params[:id])
      OrdTrab.new(@ot_anterior)
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
    if @cliente_logeado
      params[:cliente] = @cliente_logeado
    end
    inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
    final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time.end_of_day if params[:fecha_fin] && !params[:fecha_fin].blank?
    @todas = OrdTrab.apply_scopes(
      :cliente_is => params[:cliente],
      :codCliente_contains => params[:codigo_cliente],
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
          @otultsem = OrdTrab.paginate(:page => params[:page]).group_by(&:cliente_id)
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
          if params[:cliente] != ""
            @clies = params[:cliente]
            if params[:enddate].blank? && params[:startdate].blank?
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ?", @clies])
            elsif params[:startdate] != ""
              @clies = params[:cliente]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone)])
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ? and created_at <= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
              end
            elsif (params[:startdate].blank? && params[:enddate] != "")
              @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at <= ?", @clies, @fenal.to_datetime.in_time_zone(Time.zone)])
            end 
          elsif params[:startdate] != ""
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @otsel = OrdTrab.all(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)])
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otsel = OrdTrab.all(:conditions => ["created_at >= ? and created_at <= ?", @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
              end
          elsif (params[:startdate].blank? && params[:enddate] != "")
            @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
            @otsel = OrdTrab.all(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)])
          end

          @otsel = OrdTrab.all if @otsel.blank?
          
          ##################
          arre = ["CLIENTE", "NRO OT", "TIPO OT", "FECHA CREACION OT", "FECHA ENTREGA", "FECHA TERMINO", "PDF", "REVISION PDF", "PRINTER", "MATRICERIA", "MONTAJE", "REVISION", "POLIMERO", "DESPACHO", "AREA"]
          csv << arre
          ## data rows
            @otsel.each do |orden|
              # Cliente
              @elclie = orden.cliente ? orden.cliente : ""
              # NRO OT
              @numero_ot = orden.numOT
              # TIPO OT
              @tipo_ot = orden.tipoot
              # FECHA CREACION OT
              @fecha_creacion = orden.created_at.strftime("%Y-%m-%d %l:%M:%S") if orden.created_at
              # FECHA ENTREGA
              @fecha_entrega = orden.fechaEntrega.strftime("%Y-%m-%d %l:%M:%S") if orden.fechaEntrega
              # FECHA TERMINO OT
              # SI TODAS LAS TAREAS ESTAN TERMINADAS COGER LA ULTIMA TAREA SU ULTIMA INTERVENCION SU FECHA DE TERMINO
              if orden.orden_terminada
                @fecha_termino = orden.tareas.last.intervencions.last.termino.strftime("%Y-%m-%d %l:%M:%S") if orden.tareas != [] && orden.tareas.last.intervencions != [] && orden.tareas.last.intervencions.last.termino 
              end
              # PROCESOS
              ## PDF
              @pdf = orden.tareas.detipo("VistoBueno").first.state if orden.tareas.detipo("VistoBueno") != []
              ## REVISION PDF
              @revision_pdf = orden.tareas.detipo("RevisionVB").first.state if orden.tareas.detipo("RevisionVB") != []
              ## PRINTER
              @printer = orden.tareas.detipo("PRINTER").first.state if orden.tareas.detipo("Printer") != []
              ## MATRICERIA
              @matriceria = orden.tareas.detipo("Matriceria").first.state if orden.tareas.detipo("Matriceria") != []
              ## MONTAJE
              @montaje = orden.tareas.detipo("Montaje").first.state if orden.tareas.detipo("Montaje") != []
              ## REVISION
              @revision = orden.tareas.detipo("RevisionMM").first.state if orden.tareas.detipo("RevisionMM") != []
              ## POLIMERO
              @polimero = orden.tareas.detipo("Polimero").first.state if orden.tareas.detipo("Polimero") != []
              ## DESPACHO
              @despacho = orden.tareas.detipo("Facturacion").first.state if orden.tareas.detipo("Facturacion") != []
              # AREA
              #@area = orden.separacions.*.area.sum.to_f if orden.separacions
              @area = 100

              arri = [@elclie, @numero_ot, @tipo_ot, @fecha_creacion, @fecha_entrega, @fecha_termino, @pdf, @revision_pdf, @printer, @matriceria, @montaje, @revision, @polimero, @despacho, @area] 
              
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

