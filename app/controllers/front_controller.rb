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
  
  def eliminar
    tarea = Delayed::Job.find(params[:id])
    tarea.delete
    redirect_to(:back)
  end

end
