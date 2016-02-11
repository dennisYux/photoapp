class User < ActiveRecord::Base
  serialize :access_token, Hash
end
