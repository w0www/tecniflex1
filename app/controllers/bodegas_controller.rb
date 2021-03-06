class BodegasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def show
    @bodega = find_instance
    @existenlist = @bodega.existencias.apply_scopes(:search => [params[:search], :codigo], :order_by => (:polimero_id))
    @existensum = @existenlist.group_by {|polimero| polimero.id}
    @polilist = @bodega.polimeros
  end
end

