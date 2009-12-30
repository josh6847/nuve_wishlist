# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nuve_wishlist_session',
  :secret      => 'eaec1facff12f6f0a8451e5615a6f2b7b1b2ad3b6c8773a5311973c330ad07dc0de4c53d37e7d655c7fe580225864ea1b8b468c19bd07d5c057f7429fa502e60'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
