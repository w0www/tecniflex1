class IntervencionsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  auto_actions_for :tarea, [:new, :create]


  def index
    inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
    final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time if params[:fecha_fin] && !params[:fecha_fin].blank?
    hobo_index Intervencion.apply_scopes(
      :user_is => params[:user],
      :created_between => [inicial, final]
    )
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
          arre = ["Usuario", "Orden", "Proceso", "Fecha Inicio", "Fecha Termino", "Duracion"]
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
                  else
                    laor = "Sin OT"
                  end
                else
                  laor = "Sin OT"
                  elpro = "Sin Proceso"
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
                  else
                    laor = "Sin OT"
                  end
                else
                  laor = "Sin OT"
                  elpro = "Sin Proceso"
                end
              end
              if interv.termino == nil
                final = "Pendiente"
                @tiempint = Time.duracion(interv.inicio,Time.now)
              else
                final = interv.termino.strftime("%Y-%m-%d %l:%M:%S")
                
              end
                            
              arri = [ooser, laor, elpro, interv.inicio.strftime("%Y-%m-%d %l:%M:%S"), final, @tiempint]
              
              csv << arri
            end
          				
        # send it to da browsah
        end
        send_data(csv_string.force_encoding('ASCII-8BIT'),
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Intervenciones_al_%d_%m_%Y") + ".csv")
      end
    end
	end

  def create
    hobo_create do
				if params[:envio] == "terminar"
          this.tarea.lifecycle.terminar!(current_user)
				elsif params[:envio] == "recibir"
				  unless this.tarea.proceso.reinit
						this.tarea.lifecycle.recibir!(current_user)
					else
						if params[:vuelta]
							this.tarea.lifecycle.cambiar!(current_user)
						else
							this.tarea.lifecycle.recibir!(current_user)
						end
					end
			  elsif params[:envio] == "iniciar"
			  	unless this.tarea.state == "habilitada"
						this.tarea.lifecycle.reiniciar!(current_user)
					end
				end
      hobo_ajax_response if request.xhr?
    end
  end

  def update
    hobo_update do
				if params[:envio] == "terminar"
					flash[:notice] = 'Tarea ' + this.tarea.proceso.nombre + ' terminada'
          this.tarea.lifecycle.terminar!(current_user)
          this.final = true
          this.save
				elsif params[:envio] == "detener"
          this.tarea.lifecycle.detener!(current_user)
				elsif params[:envio] == "enviar"
					this.tarea.lifecycle.enviar!(current_user)
				elsif params[:envio] == "recibir"
					this.tarea.lifecycle.recibir!(current_user)
				elsif params[:envio] == "rechazar"
					if this.tarea.proceso.varev
						this.tarea.lifecycle.rechazar!(current_user)
						this.tarea.ord_trab.volver_a(Proceso.rev.first.id,current_user)
					elsif this.tarea.proceso.rev
						this.tarea.lifecycle.rechazar!(current_user)
						this.tarea.ord_trab.volver_a(params[:procdest],current_user)
					end
        end
  ##    redirect_to '/front/index' if valid?
      hobo_ajax_response if request.xhr?
    end
  end

  def do_cambiar
  	do_transition_action :cambiar do
  		redirect_to :controller => 'front', :action => 'index'
  	end
  end

end
