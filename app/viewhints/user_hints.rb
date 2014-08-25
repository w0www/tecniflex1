class UserHints < Hobo::ViewHints

  model_name "Usuarios"
  field_names :area_mtz => "Matriceria", :area_mtje => "Montaje", :area_film => "Filmacion"
  inline_booleans true
  # field_help :field1 => "Enter what you want in this field"
  # children :primary_collection1, :aside_collection1, :aside_collection2
end
