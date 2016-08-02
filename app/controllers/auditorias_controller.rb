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
    end
  end

end
