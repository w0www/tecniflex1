class TareasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  #auto_actions_for :ord_trab, :index

  def update
		hobo_update do
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

  def show
  	esta = Tarea.find(params[:id])
  	#Procesos que esten habilitados como destinos luego de la revision
  	dests = Proceso.destderev
  	#dests que pertenezcan tambien a la OT madre de esta tarea
  	@destas = dests & esta.ord_trab.tareas.*.proceso || []
  	unless esta.activa?
  		redirect_to(:controller => 'front', :action => 'index')
  	else
    	hobo_show do
    	if this.state == "terminada"
    		redirect_to(:controller => 'front', :action => 'index')
    	else
      	@sepas = this.ord_trab.separacions
      	@variabb = "Funciona"
      	if request.xhr?
      		hobo_ajax_response do
						if this.state == "terminada"
							redirect_to(:controller => 'front', :action => 'index')
						end
					end
      	end
      end
    end
    end
    if request.xhr?
    	unless esta.activa?
  			redirect_to(:controller => 'front', :action => 'index')
  		else
  			hobo_ajax_response
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


