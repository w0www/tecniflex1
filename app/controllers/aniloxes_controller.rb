class AniloxesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  auto_actions_for :impresora, [:create, :new]

end
