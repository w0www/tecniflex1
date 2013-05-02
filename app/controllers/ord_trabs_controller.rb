class OrdTrabsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  # , :except => :index


  def new
    if params[:id]
      @prima = OrdTrab.find(params[:id])
      @prima.version ||= 1
      @prima.version += 1
      @prima.save
      @primat = @prima.attributes.except('numOT','numFact','numGuia')
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

  # def update
#     hobo_update do
#       hobo_ajax_response if request.xhr?
#    end
#   end


	def index
	@clies = Cliente.all
		hobo_index do
			@ordenes = OrdTrab.paginate(:page => params[:page], :per_page => 30)
			if params[:cliente]
				@elcli = params[:cliente]
				@cocli = params[:codCliente]
				if params[:codCliente] == "Cod. Cliente"
					@ordenes = OrdTrab.paginate( :conditions => ["cliente_id = ?", @elcli], :page => params[:page], :per_page => 30 )
				else
					@ordenes = OrdTrab.paginate( :conditions => ["codCliente = ? and cliente_id = ?", @cocli, @elcli],:page => params[:page], :per_page => 30 )
				end
			elsif (params[:startdate].blank? && params[:enddate].blank?)
				@ordenes = OrdTrab.paginate(:page => params[:page], :per_page => 30)
			elsif params[:startdate] && params[:enddate]
				@from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
				@to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
				@ordenes = OrdTrab.order_by(:id).paginate(:page => params[:page], :per_page => 30, :conditions => ["created_at >= ? and created_at <= ? and state != ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone),"terminada"])

			end

		end
	end


  def show
    hobo_show do |format|
      format.html { @taras = this.sortarasigs }
      format.xml { @ord_trab = OrdTrab.find(params[:id]) }
    end
  end

  def modificar
    hobo_new do
      @ot_anterior = OrdTrab.find (params[:id])
      OrdTrab.new(@ot_anterior)
    end
  end
  
  
  index_action :tablero do
    @grupro = Grupoproc.tablero.order_by(:position)
    @clies = Cliente.all
    if params[:orden].blank? && ((params[:startdate].blank? && params[:enddate].blank?) && (params[:cliente].blank? && params[:codCliente].blank?))
	    @todas = OrdTrab.paginate(:page => params[:page], :per_page => 35)
	  elsif params[:orden]
      @orde = params[:orden]
      @todas = OrdTrab.paginate( :conditions => ["numot = ?", @orde],:page => params[:page], :per_page => 35)
    elsif params[:cliente]
    	@elcli = params[:cliente]
    	@cocli = params[:codCliente]
    	if params[:codCliente] == "Cod. Cliente"
    		@todas = OrdTrab.paginate( :conditions => ["cliente_id = ?", @elcli], :page => params[:page], :per_page => 35 )
    	else
    		@todas = OrdTrab.paginate( :conditions => ["codCliente = ? and cliente_id = ?", @cocli, @elcli],:page => params[:page], :per_page => 35 )
    	end
    elsif params[:startdate] && params[:enddate]
        @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
        @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
        @todas = OrdTrab.order_by(:id).paginate(:conditions => ["created_at >= ? and created_at <= ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone)],:page => params[:page], :per_page => 35)
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
      @todas = OrdTrab.find(:all,:conditions => ["created_at >= ? and created_at < ?",@from_date,@end_date])
    end
    hobo_ajax_response if request.xhr?
  end
 
  index_action :otscreadas do
    respond_to do |wants|
			wants.html do
          @otultsem = OrdTrab.all.group_by(&:cliente_id)
          @proces = Proceso.all.*.nombre
          if params[:cliente]
            @clies = params[:cliente]
            if (params[:startdate].blank? && params[:enddate].blank?)
              @otultsem = OrdTrab.all(:conditions => ["cliente_id = ?", @clies]).group_by(&:cliente_id)
            elsif params[:startdate]
              @clies = params[:cliente]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @otultsem = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otultsem = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ? and created_at <= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
              end
            elsif (params[:startdate].blank? && params[:enddate])
              @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
              @otultsem = OrdTrab.all(:conditions => ["cliente_id = ? and created_at <= ?", @clies, @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
            end 
          elsif params[:startdate]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @otultsem = OrdTrab.all(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
              else 
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otultsem = OrdTrab.all(:conditions => ["created_at >= ? and created_at <= ?", @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
              end
          elsif (params[:startdate].blank? && params[:enddate])
            @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
            @otultsem = OrdTrab.all(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)]).group_by(&:cliente_id)
          end
      end
      wants.csv do
  #####
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          ##################
          @otsel = OrdTrab.all
          @proces = Proceso.all.*.nombre
          @tester = 1

          if params[:cliente] != ""
            @clies = params[:cliente]
            @tester = 3
            if params[:enddate].blank? && params[:startdate].blank?
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ?", @clies])
              @tester = 4
            elsif params[:startdate] != ""
              @clies = params[:cliente]
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              @tester = 5
              if params[:enddate].blank?
                @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone)])
                @tester = 6
              else 
                @tester = 7
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at >= ? and created_at <= ?", @clies, @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
              end
            elsif (params[:startdate].blank? && params[:enddate] != "")
              @tester = 8
              @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
              @otsel = OrdTrab.all(:conditions => ["cliente_id = ? and created_at <= ?", @clies, @fenal.to_datetime.in_time_zone(Time.zone)])
            end 
          elsif params[:startdate] != ""
              @tester = 9
              @fechini = Date.strptime(params[:startdate], "%d/%m/%Y")
              if params[:enddate].blank?
                @tester = 10
                @otsel = OrdTrab.all(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)])
              else 
                @tester = 11
                @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
                @otsel = OrdTrab.all(:conditions => ["created_at >= ? and created_at <= ?", @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
              end
          elsif (params[:startdate].blank? && params[:enddate] != "")
            @tester = 12
            @fenal = Date.strptime(params[:enddate], "%d/%m/%Y")
            @otsel = OrdTrab.all(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)])
          end
          
          ##################
          arre = ["Cliente", "O.T.", "Producto", "Codigo", "Fecha Inicio", "Fecha Termino","N.Fact", "Tiempo total", "cm2 tot.", "cm2 fact."] + @proces
          csv << arre
          ## data rows
            @otsel.each do |orden|
              if orden.cliente
                @elclie = orden.cliente
              else
                @elclie = ""
              end
              @estot = orden.ciclos
              tpar = ((orden.updated_at - orden.created_at))
              @tparh = OrdTrab.duracion(orden.created_at,orden.updated_at)
              atot = orden.areatot || 0 
              if orden.numFact != nil
                factur = orden.updated_at.strftime("%Y-%m-%d %l:%M:%S")
                areafact = orden.areatot
              else
                factur = ""
                areafact = 0
              end
              @listaciclos = []
              @proces.each do |prociclo|
                if @estot.assoc(prociclo)
                  @listaciclos << @estot.assoc(prociclo)[1].to_s
                else
                  @listaciclos << ""
                end
              end  
                        
              arri = [@elclie, orden.numOT, orden.nomprod, orden.armacod, orden.created_at.strftime("%Y-%m-%d %l:%M:%S"), factur, orden.numFact, @tparh, orden.areatot, areafact] + @listaciclos 
              
              csv << arri
             end
          				
        # send it to da browsah
        end
        send_data(csv_string.force_encoding('ASCII-8BIT'),
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Ordenes fact_al_%d_%m_%Y") + ".csv")
      end
    end
  #####      
  end 
  
  index_action :vbenvios do
    @grupro = Grupoproc.tablero.order_by(:position)
        @ctes = Cliente.all
          @todas = OrdTrab.paginate(:page => params[:page], :per_page => 35)
        if params[:cliente]
          @elcli = params[:cliente]
          
          if params[:codCliente] == "Cod. Cliente"
            @todas = OrdTrab.paginate( :conditions => ["cliente_id = ?", @elcli], :page => params[:page], :per_page => 35 )
          end
        elsif params[:startdate] && params[:enddate]
            @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
            @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
            @todas = OrdTrab.order_by(:id).paginate(:conditions => ["created_at >= ? and created_at <= ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone)],:page => params[:page], :per_page => 35)
        end
        hobo_ajax_response if request.xhr?
  end
  
    
  index_action :reporte do
  	@todas = OrdTrab.find(:all)

  @clies = Cliente.all
    if params[:orden].blank? && ((params[:startdate].blank? && params[:enddate].blank?) && (params[:cliente].blank? && params[:codCliente].blank?))
	    @todas = OrdTrab.all
	  elsif params[:orden]
      @orde = params[:orden]
      @todas = OrdTrab.all
      #hobo_index OrdTrab.apply_scopes(:search => [params[:orden], :numOT], :order_by => :numOT)
    elsif params[:cliente]
    	@elcli = params[:cliente]
    	@cocli = params[:codCliente]
    	if params[:codCliente] == "Cod. Cliente"
    		@todas = OrdTrab.find( :conditions => ["cliente_id = ?", @elcli])
    	else
    		@todas = OrdTrab.find( :conditions => ["codCliente = ? and cliente_id = ?", @cocli, @elcli])
    	end
    elsif params[:startdate] && params[:enddate]
        @from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
        @to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
        @todas = OrdTrab.order_by(:id).find(:conditions => ["created_at >= ? and created_at <= ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone)])
    end

  	respond_to do |wants|
			wants.html
			wants.csv do
				csv_string = CSV.generate(:col_sep => ";") do |csv|
					# header row
					csv << ["Cliente", "Codigo_Producto",  "O.T.", "N.Fact.", "Producto", "Proceso", "Usuario", "Fecha Inicio", "Hora Inicio", "Fecha Termino", "Hora Termino", "Colores", "cm2 tot.", "Observaciones"]
					# data rows
					@todas.each do |orden|
						if orden.tareas != []
							orden.tareas.each do |tara|
								if tara.intervencions != []
									tara.intervencions.each do |inte|
                    if inte.user != nil
                      if inte.termino 
                        termi = inte.termino
                      else
                        termi = Time.at(0)
                      end
                      if orden.cliente
                        codig = orden.cliente.sigla.to_s + orden.codCliente.to_s
                      else
                        codig = "" + orden.codCliente.to_s
                      end
                      colores = orden.separacions.*.color.join(", ")           
                      csv << [orden.cliente.name, codig,  orden.numOT, orden.numFact, orden.nomprod, tara.proceso.nombre, inte.user.name, inte.inicio.strftime("%d/%m/%y"), inte.inicio.strftime("%H:%M:%S"), termi.strftime("%d/%m/%y"), termi.strftime("%H:%M:%S"), colores, orden.areatot, inte.observaciones ]
                    end
									end
								end
							end
						end
					end
				end
				# send it to the browsah
				send_data(csv_string.force_encoding('ASCII-8BIT'),
									:type => 'text/csv; charset=iso-8859-1; header=present',
									:disposition => "attachment", :filename => Time.now.strftime("Ordenes_al_%d_%m_%Y") + ".csv")
			end
		end
	end

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

