class TareasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  auto_actions_for :ord_trab, :index

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
  # *************************
  end

  def show
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

  def do_terminar
  	do_transition_action :terminar do
  	 redirect_to(:controller => 'front', :action => 'index')
  	end
  end

end


