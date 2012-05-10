class OrdTrabsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  # , :except => :index
  @prueba = 1


  def new
    if params[:id]
      @prima = OrdTrab.find(params[:id])
      @prima.version ||= 1
      @prima.version += 1
      @prima.save
      @primat = @prima.attributes.except('numOT')
      @sepas = []
      #@impre = @prima.impresora.attributes[:id]

      @prima.separacions.each do |sepa|
        @sepas << sepa.attributes.except(:ord_trab_id)
      end

      @sepash = {:separacions => @sepas}
     # @impresh = {:impresora => @impre}
      @mixest = @primat.merge(@sepash)
   #   @mixed = @mixest.merge(@impresh)
      hobo_new OrdTrab.new(@mixest) do
        this.attributes = params[:ord_trab] || {}
        hobo_ajax_response if request.xhr?
      end
    else
      hobo_new do
        this.attributes = params[:ord_trab] || {}
        hobo_ajax_response if request.xhr?
      end
    end
  end

  def edit
    hobo_show do
      this.attributes = params[:ord_trab] || {}
      hobo_ajax_response if request.xhr?
    end
  end

  show_action :mipag

  show_action :improt do
		@ord_trab = OrdTrab.find(params[:id])
	end

  def update
    hobo_update do
      hobo_ajax_response if request.xhr?
   end
  end


	def index
		hobo_index do
		  @ord_trabs = OrdTrab.all.reverse
		end
	end


  def show
    hobo_show
  	#nopol = Grupoproc.find(:all, :conditions => ["nombre != (?) AND nombre != (?)", "Polimero", "Prep"]).*.nombre
   @taras = this.tareas.find(:all, :conditions => ["proceso_id IN (?)", Proceso.asignables])
  end

  def modificar
    hobo_new do
      @ot_anterior = OrdTrab.find (params[:id])
      OrdTrab.new(@ot_anterior)
    end
  end

  index_action :tablero do
    @grupro = Grupoproc.tablero.order_by(:position)
    unless params[:orden].blank?
      @orde = params[:orden]
      @todas = OrdTrab.find(:all, :conditions => ["numot = ?", @orde])
      #hobo_index OrdTrab.apply_scopes(:search => [params[:orden], :numOT], :order_by => :numOT)
    else
      if params[:startdate].blank? && params[:enddate].blank?
        @todas = OrdTrab.find(:all)
      else
        @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
        @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
        @todas = OrdTrab.find(:all, :conditions => ["created_at > ? and created_at < ?",@from_date,@to_date])
      end
    end
    hobo_ajax_response if request.xhr?
  end


  index_action :tablerojax do
  @proces = Proceso.find(:all)
   if params[:startdate].blank? && params[:enddate].blank?
      @todas = OrdTrab.find(:all)
    else
      @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
      @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
      @todas = OrdTrab.find(:all,conditions => ["created_at >= ? and created_at < ?",@from_date,@end_date])
    end
    hobo_ajax_response if request.xhr?
  end

  index_action :reporte

  def do_eliminar
    do_transition_action :eliminar do
      redirect_to ord_trabs_path
    end
  end

  def habilitar
    transition_page_action :habilitar do
			flash[:notice] = "Habilitacion exitosa"
		end
  end



  def mail_ot
      @ot = OrdTrab.find(params[:id])
      email = render_to_string(:action => 'improt', :layout => false, :object => @ot)
      email = PDFKit.new(email)
      email.stylesheets << "#{Rails.root}/public/stylesheets/print.css"
      email = email.to_pdf
      RecibArchMailer.deliver_enviapdf(@ot,email)
      redirect_to :action => 'index'
	end

  #   @esta = OrdTrab.find (params[:id])
  #          if (@esta.visto == true) || (@esta.ptr == true)
   #           if @esta.mdi_desarrollo && @esta.mdi_ancho
  #              do_transition_action :habilitar
  #            else
  #              flash[:error] = 'Falta el desarrollo y el ancho'
  #              render 'mipag'
  #            end
  #         else
  #            do_transition_action :habilitar
 #          end

 #end

end

