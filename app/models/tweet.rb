class Tweet < ActiveRecord::Base
  # should add some vaildations as well. e.g. check for tweet content presence, tweet length
	belongs_to :user
end
