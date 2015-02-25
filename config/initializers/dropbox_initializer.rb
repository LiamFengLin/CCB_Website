require 'dropbox_sdk'

APP_KEY = 'rv9hxl9lntkcgh9'
APP_SECRET = 'eet1z0ga3gcn9zr'
ACCESS_TOKEN = 'hD7qE0d0nl0AAAAAAAAQdIr813DPXkTNNnr1m6Zvvs5KMltXFQSkY4iHvObqE8U3'

Rails.application.config.flow = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
Rails.application.config.dropbox_client = DropboxClient.new(ACCESS_TOKEN)
