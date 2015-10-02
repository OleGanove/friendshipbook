class UsersController < ApplicationController
  helper :friendship
  
  def show
  	@user = User.find(params[:id])
  end
end
