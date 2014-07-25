class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Try to use new hash style whenever possible.
  # AFAIK old things get deprecated sooner or later.
   has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }	
   validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
   # Tweets should be dependent: :destroy
   # so that if we delete a user then all of his tweets should get deleted automatically.
  has_many :tweets
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


end
