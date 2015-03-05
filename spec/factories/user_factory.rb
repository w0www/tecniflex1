FactoryGirl.define do

  factory :operador, :class => User do
    name               "Operador"
    email_address      "operador@test.com"
    password           "Secret"
    administrator      true
    iniciales          "OP"
    rol                "Operador"
  end

  # Es el único que tiene permiso para crear tareas
  # Por tanto, es el que se encarga de crear y asignar OTs
  factory :supervisor, :class => User do
    name               "Supervisor"
    email_address      "supervisor@test.com"
    password           "Secret"
    administrator      true
    iniciales          "SU"
    rol                "Supervisor"
  end

  factory :grabador, :class => User do
    name               "Grabador"
    email_address      "grabador@test.com"
    password           "Secret"
    administrator      true
    iniciales          "GE"
    rol                "Grabador"
  end

  factory :gerente, :class => User do
    name               "Gerente"
    email_address      "gerente@test.com"
    password           "Secret"
    administrator      true
    iniciales          "GE"
    rol                "Gerente"
  end

  factory :facturador, :class => User do
    name               "Facturador"
    email_address      "facturador@test.com"
    password           "Secret"
    administrator      true
    iniciales          "GE"
    rol                "Facturador"
  end

end
