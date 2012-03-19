class IntervencionsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  auto_actions_for :tarea, [:new, :create]
  
  
  def update
    hobo_update do
        @variabb = "Funciona"
        if params[:envio] == "terminar"
          @variabb = "terminando"
          this.tarea.state = "terminada"
          this.final = true
          this.tarea.save
          redirect_to '/front/index'
       elsif params[:envio] == "detener"
          @variabb = "deteniendo" 
          this.tarea.state = "detenida"
          this.tarea.save
          redirect_to '/front/index'
        end
      hobo_ajax_response if request.xhr? 
    end
  end

end
