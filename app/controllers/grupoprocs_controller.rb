class GrupoprocsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:new, :show]
  
  def index 
      @grupoprocs = Grupoproc.find(:all, :order => "position")
      hobo_ajax_response if request.xhr?
  end

end
