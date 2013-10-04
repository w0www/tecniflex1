FactoryGirl.define do
  factory :curva, :class => Curva do
    nombre      "Curva 1"
    descripcion "Descripción de la curva 1"
    impresion 'Superficie'
    lineatura 'Lineatura 1'
    association :tipomat
    association :espesor
    association :sustrato
  end

  factory :tipomat, :class => Tipomat do
    nombre      "Papel"
  end

  factory :espesor, :class => Espesor do
    calibre      2.34
  end

  factory :sustrato, :class => Sustrato do
    nombre      "Sustrato 1"
  end

end