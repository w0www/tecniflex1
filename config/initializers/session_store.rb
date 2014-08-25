# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Tecniflex_session',
  :secret      => 'c0d843ad94f3d1d0fb86685cb585c9d44775edfd277bf388fc4e2d6eef6111125e66ed4c033cc8e3065e3ed96731099b1fa72e818b50cf425ce2e4e2c8967c49'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
