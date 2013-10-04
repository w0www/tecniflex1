FactoryGirl.define do
  factory :impresora, :class => Impresora do
    name        "HP 1000"
    trapdefault 0.0
    bumpcurve   "--"
    association :cliente
    association :curva
  end

  factory :cilindro, :class => Cilindro do
    nombre "1.5"
    distorsion 1
    duplo "A"
    espesor 1
    association :impresora
  end
end
