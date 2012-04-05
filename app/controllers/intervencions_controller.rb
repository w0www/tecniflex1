class IntervencionsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  auto_actions_for :tarea, [:new, :create]
  
  
  def update
    hobo_update do
				if params[:envio] == "terminar"
          this.tarea.lifecycle.terminar!(current_user)
				elsif params[:envio] == "detener"
          this.tarea.lifecycle.detener!(current_user)
				elsif params[:envio] == "enviar"
					this.tarea.lifecycle.enviar!(current_user)
				elsif params[:envio] == "recibir"
	##			&& (params[:vuelta] == "inicio"))
					this.tarea.lifecycle.recibir!(current_user)					
        end
      redirect_to '/front/index'
      hobo_ajax_response if request.xhr? 
    end
  end

end
