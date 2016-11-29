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
                                               this.tarea.ord_trab.volver_a(Proceso.find_by_nombre(params[:procdest]).id,current_user)
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
        this.colores = params[:intervencion][:colores] if params[:intervencion][:colores] && !params[:intervencion][:colores].blank?
        this.rechazada = true
				this.tarea.lifecycle.rechazar!(current_user)
        this.termino = Time.now
        this.tarea.proceso.volver_a_revision ? this.tarea.ord_trab.volver_a(Proceso.rev.first.id,current_user) :
                                               this.tarea.ord_trab.volver_a(Proceso.find_by_nombre(params[:procdest]).id,current_user)

      end
      this.save
      hobo_ajax_response if request.xhr?
    end
  end

  index_action :mmrechazadas do
    inicial = Date.strptime(params[:startdate], '%d/%m/%Y').to_time if params[:startdate] && !params[:startdate].blank?
    final = Date.strptime(params[:enddate], '%d/%m/%Y').to_time.end_of_day if params[:enddate] && !params[:enddate].blank?
    cliente = 
#    if inicial.blank? && final.blank?
#      @tareas = Tarea.find(:all, :include => [:intervencions], :conditions => ["intervencions.rechazada = true AND proceso_id = 14"])
#    elsif inicial.blank? && final
#      @tareas = Tarea.find(:all, :include => [:intervencions], :conditions => ["intervencions.rechazada = true AND proceso_id = 14 AND intervencions.termino < ?",final])
#    elsif inicial && final.blank?
#      @tareas = Tarea.find(:all, :include => [:intervencions], :conditions => ["intervencions.rechazada = true AND proceso_id = 14 AND intervencions.inicio >", inicial])
#    elsif inicial && final
#      @tareas = Tarea.find(:all, :include => [:intervencions], :conditions => ["intervencions.rechazada = true AND proceso_id = 14 AND intervencions.inicio > ? AND intervencions.termino < ?", inicial, final])
#    end
    hobo_index Intervencion.rechazada.apply_scopes(
     :cliente_is => params[:cliente_id],
     :created_between => [inicial, final]
    )
    respond_to do |wants|
			wants.html
      wants.csv do
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          ##################
          arre = ["NRO OT", "CLIENTE", "PRODUCTO", "CODIGO DE PRODUCTO", "VERSION PRODUCTO", "TIPO OT", "FECHA CREACION OT", "HORA CREACION OT", "PROCESO DE RECHAZO", "OBS ANALISIS", "OT INCOMPLETA", "OT CON ERROR", "OBS MATRICERIA", "OBS MONTAJE", "OBS MICROPUNTO", "RIPEO", "DISTORSION", "TEXTO", "FOTO", "OBSERVACIONES VB", "COLORES","OBS RECHAZO",]
          csv << arre
          ## data rows
            @tareas.each do |t|
              orden = t.orden
              intervencion = t.intervencions.rechazada.first
              # NRO OT
              @numero_ot = orden.numOT
              # Cliente
              @elclie = orden.cliente ? orden.cliente : ""
              # Nombre
              @nombre = orden.nomprod ? orden.nomprod : ""
              # Codigo
              @codigo = orden.armacod ? orden.armacod : ""
              # Versión
              @version = orden.version ? orden.version : ""
              # TIPO OT
              @tipo_ot = orden.tipoot
              # FECHA CREACION OT
              @fecha_creacion = orden.created_at.strftime("%d/%m/%Y") if orden.created_at
              # HORA CREACION OT
              @hora_creacion = orden.created_at.strftime("%H:%M:%S") if orden.created_at
              # PROCESO DE RECHAZO
              @proceso_de_rechazo = intervencion.procdest ? intervencion.procdest : ""
              # OBS ANALISIS
              @obs_analisis = intervencion.observaciones_analisis ? intervencion.observaciones_analisis : ""
              # OT INCOMPLETA
              @ot_incompleta = intervencion.ot_incompleta ? intervencion.ot_incompleta : ""
              # OT CON ERROR
              @ot_error = intervencion.ot_error ? intervencion.ot_error : ""
              # OBS MATRICERIA
              @obs_matriceria = intervencion.observaciones_matriceria ? intervencion.observaciones_matriceria : ""
              # OBS MONTAJE
              @obs_montaje = intervencion.observaciones_montaje ? intervencion.observaciones_montaje : ""
              # OBS MICROPUNTO
              @obs_micropunto = intervencion.observaciones_micropunto ? intervencion.observaciones_micropunto : ""
              # RIPEO
              @ripeo = intervencion.ripeo ? intervencion.ripeo : ""
              # DISTORSION
              @distorsion = intervencion.distorsion ? intervencion.distorsion : ""
              # TEXTO
              @texto = intervencion.texto ? intervencion.texto : ""
              # FOTO
              @foto = intervencion.foto ? intervencion.foto : ""
              # OBSERVACIONES VB
              @obs_vb = intervencion.observaciones_vb ? intervencion.observaciones_vb : ""
              # COLORES
              @colores = intervencion.colores ? intervencion.colores : ""
              # OBS RECHAZO
              @obs_rechazo = intervencion.observaciones_rechazo ? intervencion.observaciones_rechazo : ""
              arri = [@numero_ot, @elclie, @nombre, @codigo, @version, @tipo_ot, @fecha_creacion, @hora_creacion, @proceso_de_rechazo, @obs_analisis, @ot_incompleta, @ot_error, @obs_matriceria, @obs_montaje, @obs_micropunto, @ripeo, @distorsion, @texto, @foto, @obs_vb, @colores, @obs_rechazo] 
            
              csv << arri
             end
          				
        # send it to da browsah
        end
        send_data(csv_string,
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Tareas Rechazadas %d_%m_%Y") + ".csv")
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
