class FriendshipController < ApplicationController
  before_action :setup_friends
  # Send a friend request
  def create
  	Friendship.request(@user, @friend)
  	
  	flash[:notice] = "Friend request sent."
  	redirect_to user_path(@user)
  end

  private

  def setup_friends
  	@user = current_user
  	@friend = User.find(params[:id])
  end  
end
