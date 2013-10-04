# encoding: UTF-8

require 'spec_helper'

context 'El usuario va a crear una OT' do

  before do
    Capybara.current_driver = :selenium
    gerente = FactoryGirl.create(:gerente)
    login(gerente)
  end

  it 'durante la creación de una OT la curva se autoselecciona' do
    # Al crear una impresora se autogenera un cliente y una curva
    impresora = FactoryGirl.create(:impresora)
    # También nos hace falta relacionar la curva y el cliente a través de curva_clientes
    CurvaCliente.create!(:cliente => impresora.cliente, :curva => impresora.curva)
    visit '/ord_trabs/new'
    page.should have_css('.ord-trab-curva[disabled]')
    # Seleccionamos los 4 campos
    select Cliente.last.to_s, :from => 'ord_trab[cliente_id]'
    select impresora.to_s, :from => 'ord_trab[impresora_id]'
    select Espesor.last.calibre.to_s, :from => 'ord_trab[espesor_id]'
    select 'Cdi', :from => 'ord_trab[tipofotop]'
    find_field('ord_trab[curva_id]').value.should == Curva.last.id.to_s
  end

end
