 class ConfiguracionController < ApplicationController

  hobo_controller

  def index
    if params[:export_to_xml]
      confi = Configuration.find_by_key("export_to_xml")
      confi.update_attribute(:value, "si") if confi
    elsif params[:not_export_to_xml]
      confi = Configuration.find_by_key("export_to_xml")
      confi.update_attribute(:value, "no") if confi
    elsif params[:nrot_tablero_preprensa2] && params[:nrot_tablero_preprensa2] != ""
      confi = Configuration.find_by_key("nrot_tablero_preprensa2")
      confi.update_attribute(:value, params[:nrot_tablero_preprensa2].to_i.to_s) if confi
    end
  end
end
