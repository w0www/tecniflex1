 class ConfiguracionController < ApplicationController

  hobo_controller

  def index
    if params[:export_to_xml]
      confi = Configuration.find_by_key("export_to_xml")
      confi.update_attribute(:value, "true") if confi
    elsif params[:not_export_to_xml]
      confi = Configuration.find_by_key("export_to_xml")
      confi.update_attribute(:value, "false") if confi
    end
  end
end
