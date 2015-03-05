# encoding: UTF-8

require 'spec_helper'

context 'El usuario va a crear una OT' do

  before do
    Capybara.current_driver = :selenium
    @supervisor = FactoryGirl.create(:supervisor)
    login(@supervisor)
  end

  it 'La OT se habilita automáticamente al terminar de seleccionar operadores' do
    # Crear procesos y dar permisos al supervisor para ejecutarlos
    proceso = FactoryGirl.create(:proceso_vb)
    UserLabor.create!(:user => @supervisor, :proceso => proceso)
    # Al crear un cilindro se autogenera una impresora, un cliente y una curva
    orden = FactoryGirl.create(:ord_trab, :encargado => @supervisor)
    visit "/ord_trabs/#{orden.id}"
    # Seleccionamos los operadores para las diferentes operaciones
    select 'Supervisor'
    sleep 0.3 # Dejarle un poco de tiempo a la llamada Ajax
    # Recargamos la página
    visit "/ord_trabs/#{orden.id}"
    # La OT debería haber sido habilitada automáticamente
    page.should_not have_css "input[type=submit][value='Habilitar']"
    page.should have_css "input[type=submit][value='Iniciar']"
  end

end
