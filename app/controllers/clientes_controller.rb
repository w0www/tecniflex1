class ClientesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    hobo_index Cliente.apply_scopes(:search => [params[:search],:name,:razsocial], :order_by => parse_sort_param(:name))
  end


end

