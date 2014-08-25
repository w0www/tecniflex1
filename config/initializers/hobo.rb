Hobo::ModelRouter.reload_routes_on_every_request = true
# Hobo::Dryml.precompile_taglibs if File.basename($0) != "rake" && Rails.env.production? 

# You can uncomment these tweaks to accelerate the application in dev mode. Warning: you might have to reload the app in some cases
#Hobo::ModelRouter.reload_routes_on_every_request = false
#Hobo::Dryml::DrymlGenerator.run_on_every_request = false

if Rails.env.test?
  Hobo::ModelRouter.reload_routes_on_every_request = false
  Hobo::Dryml::DrymlGenerator.run_on_every_request = false
  Hobo::Dryml.precompile_taglibs
end