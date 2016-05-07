module TooDone
  class User < ActiveRecord::Base
    has_many :sessions
    has_many :lists, foreign_key: "user_id"
  end
end
