class MovimientosController < ApplicationController

  hobo_model_controller

  auto_actions :all
  auto_actions_for :mov_header, :create
end
