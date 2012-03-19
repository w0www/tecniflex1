class TareasController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  auto_actions_for :ord_trab, :index
  
  def update
    hobo_update do
      hobo_ajax_response if request.xhr?
   end
  end
    
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

  
