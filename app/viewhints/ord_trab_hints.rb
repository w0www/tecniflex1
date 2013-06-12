class OrdTrabHints < Hobo::ViewHints

  model_name "O.T."
  field_names :mtz => "Matriceria", :mtje => "Montaje", :film => "Filmacion", :vb => "Visto Bueno", :tipofotop => "Categoria"
  # field_help :field1 => "Enter what you want in this field"
  # children :primary_collection1, :aside_collection1, :aside_collection2
  inline_booleans true
  
end
