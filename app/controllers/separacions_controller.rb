class SeparacionsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :ord_trab, [:create, :new, :index]
  
  def show
    hobo_show do
      @exaptas = Existencia.findex([this.tipomat, this.ancho, this.alto, this.grosor])
      @uniqsuno = Existencia.finduniq([this.tipomat, this.ancho, this.alto, this.grosor, 1]) || []
      @uniqsdos = Existencia.finduniq([this.tipomat, this.ancho, this.alto, this.grosor, 2]) || []
      @cuniqsuno = Existencia.countuniq([this.tipomat, this.ancho, this.alto, this.grosor, 1]) || 0
      @cuniqsdos = Existencia.countuniq([this.tipomat, this.ancho, this.alto, this.grosor, 2]) || 0
    end
  end

end
