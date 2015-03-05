FactoryGirl.define do
  factory :ord_trab, :class => OrdTrab do
    association :cliente
    nomprod "Cartel"
    association :impresora
    association :cilindro
    vb true
    barcode "1111A"
    association :espesor
    supRev 'Superficie'
    fechaEntrega Date.today
    association :curva
    association :encargado, :factory => :supervisor
    mcTacascol ""
    mcGuiacol ""
    mcPimpcol ""
    mdi_desarrollo 1
    mdi_ancho      1
  end
end
