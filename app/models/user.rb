class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :friendships

  # We don't need a source here, because Rails detects the fake "friends" table as a source
  # which we have specified in models/friendship.rb
  has_many :friends,
    		-> { Friendship.accepted },
  		   :through 	=> :friendships



  has_many :requested_friends,
   		   -> { Friendship.requested },
  		   :through 	=> :friendships, 
  		   :source 		=> :friend


  has_many :pending_friends,
    		-> { Friendship.pending },
  		   :through 	=> :friendships,
  		   :source		=> :friend

end
