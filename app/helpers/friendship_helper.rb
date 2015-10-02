module FriendshipHelper
  def friendship_status(user, friend)
  	friendship = Friendship.find_by(user: user, friend: friend)
  	return "#{friend.email} is not your friend yet." if friendship.nil?

  	case friendship.status 
  	when 'request'
  	  "#{friend.email} would like to be your friend."
  	when 'pending'
  	  "#You have request friendship from #{friend.email}."
  	when 'accepted'
  	  "#{friend.email} ist your friend."
  	end
  end
end
