class IntervencionsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  auto_actions_for :tarea, [:new, :create]
  
  
  def create
    hobo_create do
				if params[:commit] == "terminar"
          this.tarea.lifecycle.terminar!(current_user)
				elsif params[:commit] == "recibir"
					this.tarea.lifecycle.recibir!(current_user)					
        end
      hobo_ajax_response if request.xhr? 
    end
  end
  
  def update
    hobo_update do
				if params[:commit] == "terminar"
          this.tarea.lifecycle.terminar!(current_user)
				elsif params[:commit] == "detener"
          this.tarea.lifecycle.detener!(current_user)
				elsif params[:commit] == "enviar"
					this.tarea.lifecycle.enviar!(current_user)
				elsif params[:commit] == "recibir"
	##			&& (params[:vuelta] == "inicio"))
					this.tarea.lifecycle.recibir!(current_user)					
        end
  ##    redirect_to '/front/index' if valid?
      hobo_ajax_response if request.xhr? 
    end
  end

end
