class IntervencionsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  auto_actions_for :tarea, [:new, :create]


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
