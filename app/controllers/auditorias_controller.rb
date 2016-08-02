class AuditoriasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    respond_to do |wants|
			wants.html do
        inicial = Date.strptime(params[:startdate], '%d/%m/%Y').to_time if params[:startdate] && !params[:startdate].blank?
        final = Date.strptime(params[:enddate], '%d/%m/%Y').to_time.end_of_day if params[:enddate] && !params[:enddate].blank?
        @auditorias = Auditoria.apply_scopes(:created_between => [inicial, final]).paginate(:page => params[:page], :per_page => 20)
      end
      wants.csv do
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          ##################
          @fechini = params[:startdate] && params[:startdate].blank? ? "" : Date.strptime(params[:startdate], "%d/%m/%Y")
          @fenal = params[:enddate] && params[:enddate].blank? ? "" : Date.strptime(params[:enddate], "%d/%m/%Y")
          
          if @fechini != "" && @fenal.blank?
            @auditorias = Auditoria.all(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)])            
          elsif @fechini.blank? && @fenal != ""
            @auditorias = Auditoria.all(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)])
          elsif @fechini != "" && @fenal != ""
            @auditorias = Auditoria.all(:conditions => ["created_at >= ? and created_at <= ?",
                          @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
          end

          ##################
          arre = ["TIPO", "FECHA", "USUARIO", "ORDEN", "DETALLES"]
          csv << arre
          ## data rows
            @auditorias.each do |a|
              # Tipo
              @tipo = a.tipo ? a.tipo : ""
              # Fecha
              @fecha = a.fecha.strftime("%d/%m/%Y %H:%M:%S")
              # Usuario
              @usuario = a.user ? a.user : ""
              # NRO OT
              @orden = a.ord_trab ? a.ord_trab : ""
              # Detalles
              @detalles = a.detalles ? a.detalles : ""
              arri = [@tipo, @fecha, @usuario, @orden, @detalles] 
              csv << arri
            end
          				
        # send it to da browsah
        end
        send_data(csv_string,
                  :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment", :filename => Time.now.strftime("Auditorias %d_%m_%Y") + ".csv")
      end
    end
  end

end




