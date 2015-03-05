FactoryGirl.define do
  factory :cliente, :class => Cliente do
    name      "Zapatería Juan"
    razsocial "Zapateria Juan S.L."
    sigla     "ZJ"
    correo    "juan@zapateriajuan.com"
  end
end