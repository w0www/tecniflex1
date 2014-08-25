class ProductoHints < Hobo::ViewHints

  # model_name "My Model"
  field_names :name => "Nombre", :codTflex => "Codigo Tecniflex", :codCliente => "Codigo Cliente", :mdi_desarrollo => "Desarrollo", :mdi_ancho => "Ancho"
  # field_help :field1 => "Enter what you want in this field"
  # children :primary_collection1, :aside_collection1, :aside_collection2
	children :ord_trabs
end
