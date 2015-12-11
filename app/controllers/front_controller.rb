class FrontController < ApplicationController

  hobo_controller

  def index
    unless current_user.guest?
      if Cliente.find_by_correo(current_user.email_address)
        redirect_to "/ord_trabs/tablero"
      else
        @ordenes = OrdTrab.find :all
        @asignacions = current_user.asignacions.disp(:all, :include => [:proceso => :grupoproc], :order => "grupoprocs.position")
      end
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
    @hora_actual = DateTime.now.in_time_zone
    @grupro = Grupoproc.tablero.order_by(:position)
    @clies = Cliente.all
    @todas = OrdTrab.find(:all, :order => "fechaEntrega desc", :limit => 20)
    @users = User.find(:all, :conditions => ["tablero = true"])
  end

  def polimeros
    @hora_actual = DateTime.now.in_time_zone
    id_polimero = Proceso.find_by_nombre("polimero").id
    id_revisionmm = Proceso.find_by_nombre("revisionmm").id
    # id_facturacion = Proceso.find_by_nombre("facturacion").id
    @tareas = Tarea.find(:all, :conditions => ["proceso_id IN (?) AND state IN (?)", [id_polimero,id_revisionmm],["habilitada","iniciada", "detenida","enviada","recibida", "en_revision"]], :include => [:proceso => :grupoproc], :order => "grupoprocs.position")

    # Calcular las paginas totales
    if @tareas.count <= 20
      paginas_totales = 1
    elsif @tareas.count > 20
      paginas_totales = (@tareas.count / 20) + 1      
    end
    # Entramos en /front/polimeros
    if !params[:page]
      params[:page] = 1
      @pagina_siguiente = paginas_totales == 1 ? 1 : 2
    elsif params[:page]
      # Si recibimos params[:id]
      if paginas_totales > 1
        @pagina_siguiente = params[:page].to_i + 1
        if params[:page].to_i == paginas_totales
          @pagina_siguiente = 1
        end
      else
        @pagina_siguiente = 1
      end
    end
    @tareas = @tareas.paginate(:page => params[:page], :per_page => 20)
  end
  
  def eliminar
    tarea = Delayed::Job.find(params[:id])
    tarea.delete
    redirect_to(:back)
  end

end
