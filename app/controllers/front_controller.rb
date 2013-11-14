class FrontController < ApplicationController

  hobo_controller

  def index
    unless current_user.guest?
      @ordenes = OrdTrab.find :all
      @asignacions = current_user.asignacions.activa(:all, :include => [:proceso => :grupoproc], :order => "grupoprocs.position")
    end    
  end
  
  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end
  
  def cola
    @cola = Delayed::Job.all
  end

  def pantalla
    @hora_actual = DateTime.now
    @grupro = Grupoproc.tablero.order_by(:position)
    @clies = Cliente.all
    inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
    final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time if params[:fecha_fin] && !params[:fecha_fin].blank?
    @todas = OrdTrab.apply_scopes(
      :cliente_is => params[:cliente],
      :codCliente_contains => params[:codigo_cliente],
      :numOT_contains => params[:orden],
      :state_is => params[:estado],
      :created_between => [inicial, final]
    ).paginate(:page => params[:page], :per_page => 35)
    hobo_ajax_response if request.xhr?
  end
  
  def eliminar
    tarea = Delayed::Job.find(params[:id])
    tarea.delete
    redirect_to(:back)
  end

end
