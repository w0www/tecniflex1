class RecursosController < ApplicationController  
  hobo_model_controller

  auto_actions :all

  show_action :ordenador do
    @recurso = Recurso.find(params[:id])
    @tareas = Tarea.find :all, :conditions => ["state != ?", "terminada"]
  end
end
