class IntervencionsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  auto_actions_for :tarea, [:new, :create]


  def index
    inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
    final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time if params[:fecha_fin] && !params[:fecha_fin].blank?
    if params[:state] && params[:state] == "rechazada"
      hobo_index Intervencion.rechazada.apply_scopes(
        :user_is => params[:user],
        :created_between => [inicial, final]
      )
    else
      hobo_index Intervencion.apply_scopes(
        :user_is => params[:user],
        :created_between => [inicial, final]
      )
    end
    respond_to do |wants|
			wants.html 
      wants.csv do
  #####
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          ##################
          @otsel = OrdTrab.all
          if params[:user] != ""
            @usuario = params[:user]
            if params[:fecha_ini].blank? && params[:fecha_fin].blank?
              @intec = Intervencion.user_is(@usuario)
            elsif inicial
              @usuario = params[:user]
              if final
                @intec = Intervencion.created_between(inicial,final).user_is(@usuario)
              else 
                @intec = Intervencion.created_after(inicial).user_is(@usuario)
              end
            elsif (!inicial && final)
              @intec = Intervencion.created_before(final).user_is(@usuario)
            end 
          elsif inicial
              if !final
                @intec = Intervencion.created_after(inicial)
              else 
                @intec = Intervencion.created_between(inicial,final)
              end
          elsif (!inicial && final)
            @intec = Intervencion.created_before(final)
          end
          
          ##################
          arre = ["Usuario", "Orden", "N.OT.", "Proceso", "Ciclo", "Fecha Inicio", "Fecha Termino", "Duracion1", "Duracion2"]
          csv << arre
          ## data rows
            @intec.each do |interv|
              if interv.user
                ooser = interv.user
                if interv.tarea != nil
                  if interv.tarea.proceso != nil
                    elpro = interv.tarea.proceso.nombre
                  else
                    elpro = "Sin Proceso"
                  end
                  if interv.tarea.ord_trab != nil
                    laor = interv.tarea.ord_trab.armacod
                    nuot = interv.tarea.ord_trab.numOT
                  else
                    laor = "Sin OT"
                    nuot = "Sin OT"
                  end
                  elciclo = interv.tarea.ciclo
                else
                  laor = "Sin OT"
                  elpro = "Sin Proceso"
                  nuot = "Sin OT"
                  elciclo = "Sin OT"
                end
              else
                ooser = "Sin Usuario"
                if interv.tarea != nil
                  if interv.tarea.proceso != nil
                    elpro = interv.tarea.proceso.nombre
                  else
                    elpro = "Sin Proceso"
                  end
                  if interv.tarea.ord_trab != nil
                    laor = interv.tarea.ord_trab.armacod
                    nuot = interv.tarea.ord_trab.numOT
                  else
                    laor = "Sin OT"
                    nuot = "Sin OT"
                  end
                  elciclo = interv.tarea.ciclo
                else
                  laor = "Sin OT"
                  elpro = "Sin Proceso"
                  nuot = "Sin OT"
                  elciclo = "Sin OT"
                end
              end
              if interv.termino == nil
                final = "Pendiente"
                @tiempint = Time.duracion(interv.inicio,Time.now)
              else
                final = interv.termino.strftime("%Y-%m-%d %l:%M:%S")
                @tiempint = Time.duracion(interv.inicio,interv.termino)
              end
                            
              arri = [ooser, laor, nuot, elpro, elciclo, interv.inicio.strftime("%Y-%m-%d %l:%M:%S"), final, @tiempint, Time.duracion(interv.created_at,interv.updated_at)]
              
              csv << arri
            end
          				
        # send it to da browsah
        end
        send_data(csv_string,
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Intervenciones_al_%d_%m_%Y") + ".csv")
      end
    end
	end

  def create
    hobo_create do
      ord_trab = this.tarea.ord_trab
			if params[:envio] == "terminar"
        flash[:notice] = 'Tarea ' + this.tarea.proceso.nombre + ' terminada'
        this.termino = Time.now
        this.final = true
        this.tarea.lifecycle.terminar!(current_user)
        # Actualizamos la Orden para actualizar el codigo de color
        ord_trab.update_attribute(:color, ord_trab.calcular_color_tablero(ord_trab)) if ord_trab.tareas_terminadas? && ord_trab.color.blank?
      elsif params[:envio] == "recibir"
        params[:vuelta] ? this.tarea.lifecycle.cambiar!(current_user) : this.tarea.lifecycle.recibir!(current_user)
        this.rechazada = true
        this.termino = Time.now
		  elsif params[:envio] == "iniciar"
		  	unless this.tarea.state == "habilitada"
          this.inicio = Time.now
					this.tarea.lifecycle.reiniciar!(current_user)
				end
      elsif params[:envio] == "rechazar"
        this.colores = "#{params[:intervencion][:colores].join(",")}" if params[:intervencion][:colores] && !params[:intervencion][:colores].blank?
        this.rechazada = true
				this.tarea.lifecycle.rechazar!(current_user)
        this.termino = Time.now
        this.tarea.proceso.volver_a_revision ? this.tarea.ord_trab.volver_a(Proceso.rev.first.id,current_user) :
                                               this.tarea.ord_trab.volver_a(params[:procdest],current_user)
      elsif params[:envio] == "enviar"
				this.tarea.lifecycle.enviar!(current_user)
        this.termino = Time.now
      elsif params[:envio] == "enviar_pdf"
        this.tarea.lifecycle.enviar_pdf!(current_user)
        this.termino = Time.now
        redirect_to "/"
			end
      this.save
      hobo_ajax_response if request.xhr?
    end
  end

  def update
    hobo_update do
      ord_trab = this.tarea.ord_trab
      if params[:envio] == "terminar"
        flash[:notice] = 'Tarea ' + this.tarea.proceso.nombre + ' terminada'
        this.tarea.lifecycle.terminar!(current_user)
        this.termino = Time.now
        this.final = true
        ord_trab.update_attribute(:color, ord_trab.calcular_color_tablero(ord_trab)) if ord_trab.tareas_terminadas? && ord_trab.color.blank?
			elsif params[:envio] == "detener"
        this.tarea.lifecycle.detener!(current_user)
        this.termino = Time.now
			elsif params[:envio] == "enviar"
				this.tarea.lifecycle.enviar!(current_user)
        this.termino = Time.now
      elsif params[:envio] == "enviar_pdf"
        this.tarea.lifecycle.enviar_pdf!(current_user)
        this.termino = Time.now
        this.save
        redirect_to "/"
			elsif params[:envio] == "recibir"
				this.tarea.lifecycle.recibir!(current_user)
        this.rechazada = true
        this.termino = Time.now
			elsif params[:envio] == "rechazar"
        this.colores = params[:intervencion][:colores].join(",") if params[:intervencion][:colores] && !params[:intervencion][:colores].blank?
        this.rechazada = true
				this.tarea.lifecycle.rechazar!(current_user)
        this.termino = Time.now
        this.tarea.proceso.volver_a_revision ? this.tarea.ord_trab.volver_a(Proceso.rev.first.id,current_user) :
                                               this.tarea.ord_trab.volver_a(params[:procdest],current_user)

      end
      this.save
      hobo_ajax_response if request.xhr?
    end
  end

  index_action :mmrechazadas do
 #   @intervencions = Intervencion.find(:all, :joins => :tarea, :conditions => "rechazada IS true AND tareas.proceso_id = 14")
    respond_to do |wants|
			wants.html do
        inicial = Date.strptime(params[:startdate], '%d/%m/%Y').to_time if params[:startdate] && !params[:startdate].blank?
        final = Date.strptime(params[:enddate], '%d/%m/%Y').to_time.end_of_day if params[:enddate] && !params[:enddate].blank?
        @intervencions = Intervencion.apply_scopes(
          :created_between => [inicial, final],
          :rechazada_is => true
        ).paginate(:page => params[:page], :per_page => 20)
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
          arre = ["CLIENTE", "NOMBRE", "NUM FACTURA", "CODIGO", "NRO OT", "TIPO OT", "FECHA CREACION OT", "HORA CREACION OT", "FECHA ENTREGA", "HORA ENTREGA", "FECHA TERMINO", "HORA TERMINO", "PDF", "REVISION PDF", "PRINTER", "MATRICERIA", "MONTAJE", "REVISION", "POLIMERO", "DESPACHO", "AREA",]
          csv << arre
          ## data rows
            @otsel.each do |orden|
              tareas = orden.tareas
              # Cliente
              @elclie = orden.cliente ? orden.cliente : ""
              # Nombre
              @nombre = orden.nomprod ? orden.nomprod : ""
              # Numero de factura ### falta por programar
              @numero_factura = orden.numFact ? orden.numFact : ""
              # Codigo
              @codigo = orden.armacod ? orden.armacod : ""
              # NRO OT
              @numero_ot = orden.numOT
              # TIPO OT
              @tipo_ot = orden.tipoot
              # FECHA CREACION OT
              @fecha_creacion = orden.created_at.strftime("%d/%m/%Y") if orden.created_at
              # HORA CREACION OT
              @hora_creacion = orden.created_at.strftime("%H:%M:%S") if orden.created_at
              # FECHA ENTREGA
              @fecha_entrega = orden.fechaEntrega.strftime("%d/%m/%Y") if orden.fechaEntrega
              # HORA ENTREGA
              @hora_entrega = orden.fechaEntrega.strftime("%H:%M:%S") if orden.fechaEntrega
              # FECHA TERMINO OT
              # SI TODAS LAS TAREAS ESTAN TERMINADAS COGER LA ULTIMA TAREA SU ULTIMA INTERVENCION SU FECHA DE TERMINO
              if orden.orden_terminada
                if tareas != [] && tareas.last.intervencions != [] && tareas.last.intervencions.last.termino
                  @fecha_termino = tareas.last.intervencions.last.termino.strftime("%d/%m/%Y") 
                  @hora_termino = tareas.last.intervencions.last.termino.strftime("%H:%M:%S")
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
              arri = [@elclie, @nombre, @numero_factura,@codigo, @numero_ot, @tipo_ot, @fecha_creacion, @hora_creacion, @fecha_entrega, @hora_entrega, @fecha_termino, @hora_termino, @pdf, @revision_pdf, @printer, @matriceria, @montaje, @revision, @polimero, @despacho, @area] 
            
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


  def do_cambiar
  	do_transition_action :cambiar do
  		redirect_to :controller => 'front', :action => 'index'
  	end
  end

end
