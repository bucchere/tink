json.extract! user, :id, :name, :mobile, :invited_by, :next_ask, :provider, :uid, :oauth_token, :oauth_expires_at, :created_at, :updated_at
json.url user_url(user, format: :json)