class ImpresorasController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  
  auto_actions_for :cliente, [ :index, :new, :create ]

end
