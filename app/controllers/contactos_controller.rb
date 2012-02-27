class ContactosController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  auto_actions_for :cliente, [ :index, :new, :create ]

end
