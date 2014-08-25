class ClientesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    hobo_index Cliente.apply_scopes(:search => [params[:search],:name,:razsocial], :order_by => parse_sort_param(:name))
  end

  index_action :reportecli do
    conditions = []
    conditions << [ "name = ?", params[:name] ] if params[:name].present?
    conditions << [ "fecha_inicial >= ?", params[:fecha_inicial] ] if params[:fecha_inicial].present?
    conditions << [ "fecha_final <= ?", params[:fecha_final] ] if params[:fecha_final].present?
    @todos = Cliente.all(:conditions => conditions )
  
    #if params[:orden].blank? && ((params[:startdate].blank? && params[:enddate].blank?) && (params[:cliente].blank? && params[:codCliente].blank?))
	    #@todas = OrdTrab.all
	  #elsif params[:orden]
      #@orde = params[:orden]
      #@todas = OrdTrab.all
      ##hobo_index OrdTrab.apply_scopes(:search => [params[:orden], :numOT], :order_by => :numOT)
    #elsif params[:cliente]
    	#@elcli = params[:cliente]
    	#@cocli = params[:codCliente]
    	#if params[:codCliente] == "Cod. Cliente"
    		#@todas = OrdTrab.find( :conditions => ["cliente_id = ?", @elcli])
    	#else
    		#@todas = OrdTrab.find( :conditions => ["codCliente = ? and cliente_id = ?", @cocli, @elcli])
    	#end
    #elsif params[:startdate] && params[:enddate]
        #@from_date = Date.strptime(params[:startdate],"%d/%m/%Y")
        #@to_date = Date.strptime(params[:enddate],"%d/%m/%Y")
        #@todas = OrdTrab.order_by(:id).find(:conditions => ["created_at >= ? and created_at <= ?",@from_date.to_datetime.in_time_zone(Time.zone),@to_date.to_datetime.in_time_zone(Time.zone)])
    #end

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
                    atot = 0
                    atot = orden.separacions.sum("area")     
                    colores = orden.separacions.*.color.join(", ")           
										csv << [orden.cliente.name, codig,  orden.numOT, orden.numFact, orden.nomprod, tara.proceso.nombre, inte.user.name, inte.inicio.strftime("%d/%m/%y"), inte.inicio.strftime("%H:%M:%S"), termi.strftime("%d/%m/%y"), termi.strftime("%H:%M:%S"), colores, atot, inte.observaciones ]
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

end

