FactoryGirl.define do
  factory :proceso_vb, :class => Proceso do
    association :grupoproc, :factory => :grupoproc_vb
    nombre 'VistoBueno'
    descripcion 'Preparación y visto Bueno'
  end
  factory :grupoproc_vb, :class => Grupoproc do
    nombre 'Visto Bueno'
    abreviacion 'visto'
    tablero true
    asignar true
    saevb true
  end
end