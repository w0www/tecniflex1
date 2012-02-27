class TareasController < ApplicationController

  hobo_model_controller

  auto_actions :all
    
  def show
    hobo_show do
      @sepas = this.ord_trab.separacions
      @variabb = "Funciona"
      hobo_ajax_response if request.xhr? do
      if params[:envio] == "terminar"
        @variabb = "terminando"
        this.state = "terminada"
        this.save
      else
        if params[:envio] == "detener"
        @variabb = "deteniendo" 
        this.state = "detenida"
        this.save
        end
      end
    end
    end
  end

end

  
