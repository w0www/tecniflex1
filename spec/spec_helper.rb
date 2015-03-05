require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
require 'database_cleaner'

Spork.prefork do
  ENV["RAILS_ENV"] = 'test'
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))

  require 'spec/autorun'
  require 'spec/rails'

  require 'selenium/webdriver'
  require 'rack/handler/mongrel'
  require 'selenium/webdriver/firefox/bridge'

  require 'capybara/rails'
  require 'capybara/dsl' 
  require 'capybara/webkit'

  require 'factory_girl'
  FactoryGirl.find_definitions
  
  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = false
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    # Activar Capybara
    config.include(Capybara::DSL, :type => [:integration, :acceptance])
    # Limpiar la base de datos antes de empezar
    config.before(:suite) { 
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
    }
  end
end

Spork.each_run do
  # Recargamos los helpers en cada ejecución
  require 'spec/integration_helper'
end
