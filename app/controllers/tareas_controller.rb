# encoding: utf-8
class TareasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  #auto_actions_for :ord_trab, :index

  def update
    asignacion = params[:tarea][:asignada_a].blank? ? false : true
		hobo_update do
      if this.ord_trab && this.ord_trab.tarasigs || asignacion
        # Si alguna tarea esta asignada
        this.ord_trab.lifecycle.habilitar!(current_user) if asignacion && this.ord_trab.state == "creada"
        # Si todas estan terminadas es porque vamos paso a paso y necesitamos habilitar la tarea
        comprueba_si_necesita_activar
        unless this.ord_trab.errors.blank?
          flash[:error] = "Aunque todas las tareas de la OT #{this.ord_trab.numOT} ya estan asignadas, no se ha podido habilitar automaticamente la OT debido a los siguientes errores: #{this.ord_trab.errors.full_messages}"
        end
      end
      if request.xhr?
        if this.state == "terminada"
          render :json => {
            :location => url_for(:controller => 'front', :action => 'index')
          }
				else
					hobo_ajax_response
				end
			end
		end
  end

  def comprueba_si_necesita_activar
    # Si necesitamos activar vamos a necesitar activar la primera tarea que solo este en estado activar
    # Semaforo = true porque pensamos que todas estan acabadas
    semaforo = true
    for tarea in this.ord_trab.sortars
      semaforo = false if tarea.state != 'terminada'
      t = tarea
      if semaforo == false
        break
      end
    end
    t.lifecycle.habilitar!(current_user) if semaforo == false
  end

  def show
    @tarea = Tarea.find(params[:id])
    @termin = 0
    @intervenciones = @tarea.intervencions.find(:all, :joins => :user, :conditions => ["name = ?", current_user.name])
    @select_users = User.all.map{|u| [u.name, u.id]}
    
    # Si una tarea pasa a iniciada la orden de trabajo tiene que pasar a iniciada tambien
    if @tarea.state == "iniciada" && @tarea.ord_trab.state == "creada"
      @tarea.ord_trab.lifecycle.iniciar!(current_user)
    end
    
  	# Procesos que esten habilitados como destinos luego de la revision
  	procesos_filtrados = Proceso.volver_desde_revision
  	@procesos_volver_desde_revision = procesos_filtrados & @tarea.ord_trab.tareas.*.proceso || []
  	unless @tarea.activa?
  		redirect_to(:controller => 'front', :action => 'index')
  	else
    	hobo_show do
      	if this.state == "terminada"
      		redirect_to(:controller => 'front', :action => 'index')
      	else
        	@separaciones = this.ord_trab.separacions
        	@variabb = "Funciona"
        	if request.xhr?
        		hobo_ajax_response do
  					  redirect_to(:controller => 'front', :action => 'index') if this.state == "terminada"
					  end
        	end
        end
      end
    end
  end

  def terminar
  	creator_page_action :terminar
  	flash[:notice] = 'Terminar sin do_'
  	redirect_to '/front/index'
  end

  def do_terminar
  	do_transition_action :terminar do
			flash[:notice] = 'Tarea #{this.proceso.nombre} de orden #{this.ord_trab.numOT} terminada'
			redirect_to '/front/index'
  	end
  end

end


