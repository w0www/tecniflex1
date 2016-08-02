class AuditoriasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    respond_to do |wants|
			wants.html do
        inicial = Date.strptime(params[:fecha_ini], '%d/%m/%Y').to_time if params[:fecha_ini] && !params[:fecha_ini].blank?
        final = Date.strptime(params[:fecha_fin], '%d/%m/%Y').to_time.end_of_day if params[:fecha_fin] && !params[:fecha_fin].blank?
        @auditorias = Auditoria.apply_scopes(:created_between => [inicial, final]).paginate(:page => params[:page], :per_page => 20)
      end
      wants.csv do
        csv_string = CSV.generate(:col_sep => ";") do |csv|
          ##################
          inicial = params[:fecha_ini] && params[:fecha_ini].blank? ? "" : Date.strptime(params[:fecha_ini], "%d/%m/%Y")
          final = params[:fecha_fin] && params[:fecha_fin].blank? ? "" : Date.strptime(params[:fecha_fin], "%d/%m/%Y")

          if @fechini != "" && @fenal.blank?
            @auditorias = Auditoria.apply_scopes(:created_between => [inicial, final])
            @auditorias = Auditoria.all(:conditions => ["created_at >= ?", @fechini.to_datetime.in_time_zone(Time.zone)])            
          elsif @fechini.blank? && @fenal != ""
            @auditorias = Auditoria.all(:conditions => ["created_at <= ?", @fenal.to_datetime.in_time_zone(Time.zone)])
          elsif @fechini != "" && @fenal != ""
            @auditorias = Auditoria.all(:conditions => ["created_at >= ? and created_at <= ?",
                          @fechini.to_datetime.in_time_zone(Time.zone), @fenal.to_datetime.in_time_zone(Time.zone)])
          else
            @auditorias = Auditoria.all
          end

          ##################
          arre = ["TIPO", "FECHA", "USUARIO", "ORDEN", "DETALLES"]
          csv << arre
          ## data rows
            for a in @auditorias
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




