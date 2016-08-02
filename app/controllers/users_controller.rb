class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all

  def edit
    hobo_show do
      hobo_ajax_response if request.xhr?
    end
  end

  def do_reset_password
    do_transition_action :reset_password do
      redirect_to(:controller => "users", :action => "index")
    end
  end

  def login
    usuario = User.find_by_email_address(params[:login]).blank? ? "" : User.find_by_email_address(params[:login])
    detalles = usuario.blank? ? "Usuario no existe" : ""
    hobo_login do
      Auditoria.create(
        :tipo => "login",
        :fecha => DateTime.now,
        :user_id => usuario,
        :detalles => detalles
      )
    end
  end

  index_action :intervs do
    @grupro = Grupoproc.tablero.order_by(:position)
    @clies = Cliente.all
    @usuarios = User.all
    if params[:user].blank?
	    @todas = User.paginate(:conditions => ["name = ?", "jeim"],:page => params[:page], :per_page => 35)
	  elsif params[:startdate] && params[:enddate]
	  	from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
	  	to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
	    @usuario = User.find(params[:user])
      @todas = @usuario.intervencions.paginate(:conditions => ["created_at >= ? and created_at <= ?",from_date,to_date],:page => params[:page], :per_page => 35)

		end
    hobo_ajax_response if request.xhr?
  end
   
  #######################
  index_action :opers do
    respond_to do |wants|
      inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
      final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time if params[:fecha_fin] && !params[:fecha_fin].blank?
      User.apply_scopes(
      :user_is => params[:cliente],
      :created_between => [inicial, final]
      )
			wants.html do
          #@otultsem = OrdTrab.paginate(:page => params[:page]).group_by(&:cliente_id)
          #@proces = Proceso.all.*.nombre
           @proces = Proceso.all.*.nombre
            @intervs = []
          if params[:operador]
            @operador = params[:operador]
            @ope = User.find(@operador).name || "Sin Operador"
            auxi = User.find @operador, :include => {:tareas => :ord_trab}
            if (params[:startdate].blank? && params[:enddate].blank?)
              Eluno = User.find 1, :include => {:tareas => :ord_trab}
              @intervs = auxi.intervencions.group_by(&:tarea_id)
              #intervs = User.find (includes(:tareas=>:ord_trab).paginate(:conditions => ["user_id = ?", @operador],:page => params[:page]).group_by(&:id)
            elsif params[:startdate]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @intervs = User.includes(:tareas=>:ord_trab).paginate(:conditions => ["user_id = ? and ord_trab.created_at >= ?", @operador, @fechini.to_datetime.in_time_zone(Time.zone)],:page => params[:page]).group_by(&:id)
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @intervs = User.includes(:tareas=>:ord_trab).paginate(:conditions => ["cliente_id = ? and created_at >= ? and created_at <= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)],:page => params[:page]).group_by(&:id)
              end
            elsif (params[:startdate].blank? && params[:enddate])
              @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
              @intervs = User.includes(:tareas=>:ord_trab).paginate(:conditions => ["cliente_id = ? and created_at <= ?", @clies, @fenal.to_datetime.in_time_zone(Time.zone)],:page => params[:page]).group_by(&:id)
            end 
          elsif params[:startdate]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @intervs = User.includes(:tareas=>:ord_trab).paginate(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)]).group_by(&:id)
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @intervs = User.includes(:tareas=>:ord_trab).paginate(:conditions => ["created_at >= ? and created_at <= ?", @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:id)
              end
          elsif (params[:startdate].blank? && params[:enddate])
            @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
            @intervs = User.includes(:tareas=>:ord_trab).paginate(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:id)
          else
            auxi = User.find User.first.id, :include => {:tareas => :ord_trab}
            @intervs = auxi.intervencions.group_by(&:tarea_id)  
            @ope = User.first      
          end
          
      end
      wants.csv do
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          #@otsel = OrdTrab.all
          @proces = Proceso.all.*.nombre
          if params[:operador] != ""
            @operador = params[:operador]
            if params[:enddate].blank? && params[:startdate].blank?
              @intervs = User.includes(:tareas=>:ord_trab).all(:conditions => ["id = ?", @operador])
            elsif params[:startdate] != ""
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @intervs = User.includes(:tareas=>:ord_trab).all(:conditions => ["id = ? and created_at >= ?", @operador, @fechini.to_datetime.in_time_zone(Time.zone)])
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @intervs = User.includes(:tareas=>:ord_trab).all(:conditions => ["id = ? and created_at >= ? and created_at <= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
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
          else
            @intervs = User.includes(:tareas=>:ord_trab).all
          end
          
          arre = ["Cliente", "O.T.", "Producto", "Codigo", "Fecha Inicio", "Fecha Termino","N.Fact", "Tiempo bruto", "Tiempo neto", "cm2 tot.", "cm2 fact.", "F. V.B.", "E. V.B.", "F. PTR", "E. PTR"] + @proces
          csv << arre
          ## data rows
            @otsel.each do |orden|
              if orden.tareas
                primpro = Proceso.prueba.first.id
                secpro = Proceso.prueba.second.id
                if primpro != nil
                  @primpru = orden.tareas.all(:conditions => ["proceso_id = ?", primpro]).first
                end
                if secpro != nil
                  @secpru = orden.tareas.all(:conditions => ["proceso_id = ?", secpro]).first
                end
              end
              if orden.cliente
                @elclie = orden.cliente
              else
                @elclie = ""
              end
              @estot = orden.ciclos
              tpar = ((orden.updated_at - orden.created_at))
              @tparh = Time.duracion(orden.created_at,orden.updated_at)
              atot = orden.areatot || 0 
              if orden.numFact != nil
                factur = orden.updated_at.strftime("%Y-%m-%d %l:%M:%S")
                areafact = orden.areatot
              else
                factur = ""
                areafact = 0
                
              end
              @listaciclos = []
              @proces.each do |prociclo|
                if @estot.assoc(prociclo)
                  @listaciclos << @estot.assoc(prociclo)[1].to_s
                else
                  @listaciclos << ""
                end
              end 
              if @primpru != nil
                @estprimpru = @primpru.state
                if @primpru.intervencions != []
                  if @primpru.intervencions.last.termino != nil
                    @ultintvb = @primpru.intervencions.last.termino.strftime("%Y-%m-%d %l:%M:%S")
                  else
                    @ultintvb = @primpru.intervencions.last.inicio.strftime("%Y-%m-%d %l:%M:%S")
                  end
                else
                  @ultintvb = ""
                end
              else
                @ultintvb = ""
                @estprimpru = ""
              end
              if @secpru != nil
                @estsecpru = @secpru.state
                if @secpru.intervencions != []
                  if @secpru.intervencions.last.termino != nil
                    @ultintptr = @secpru.intervencions.last.termino.strftime("%Y-%m-%d %l:%M:%S")
                  else
                    @ultintptr = @secpru.intervencions.last.inicio.strftime("%Y-%m-%d %l:%M:%S")
                  end
                else
                  @ultintptr = ""
                end
              else 
                @ultintptr = ""
                @estsecpru = ""
              end
              @tiempot = Time.duracion(Time.at(0),orden.tnetot)
              @FVB = orden
              arri = [@elclie, orden.numOT, orden.nomprod, orden.armacod, orden.created_at.strftime("%Y-%m-%d %l:%M:%S"), factur, orden.numFact, @tparh, @tiempot, orden.areatot, areafact, @ultintvb, @estprimpru, @ultintptr, @estsecpru] + @listaciclos 
              
              csv << arri
             end
          				
        # send it to da browsah
        end
        send_data(csv_string.force_encoding('ASCII-8BIT'),
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Ordenes fact_al_%d_%m_%Y") + ".csv")
      end
    end
  end 
  #######################

end
