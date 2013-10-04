FactoryGirl.define do
  factory :impresora, :class => Impresora do
    name        "HP 1000"
    trapdefault 0.0
    bumpcurve   "--"
    association :cliente
    association :curva
  end
end