# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hhac2_session',
  :secret      => 'c42cee4be591d12e4208f0d3c0841dcbc54da14c9074080ef17420e6b352bb5ae38ac423bf141d511c182b69f9e82c9bb1189e0c34e8632e70fd5d78a7b01b89'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
