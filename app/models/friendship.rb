class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"

  validates :user_id, presence: true
  validates :friend_id, presence: true

  scope :accepted, -> { where(status: :accepted) } # unsure whether this works
  scope :pending,  -> { where(status: :pending).order("created_at") }
  scope :requested,  -> { where(status: :request).order("created_at") }

  # Return true if users are (possibly pending) friends.

  def self.exists?(user, friend)
  	not find_by(user: user, friend: friend).nil?
  end

  # Record a pending friend request
  
  def self.request(user, friend)
  	unless user == friend || Friendship.exists?(user, friend)
  	  # Because of transaction both "create"s are called simultaneously
  	  transaction do
  	  	# We don't need to write :user_id = > user.id etc. 
  	  	# Rails knows to look at IDs 
  		create(:user => user, :friend => friend, :status => 'pending')	
  		create(:user => friend, :friend => user, :status => 'request')	
  	  end
  	end
  end

  # Accept a friend request

  def self.accept(user, friend)
  	transaction do
  	  accepted_at = Time.now
  	  accept_one_side(user, friend, accepted_at)
  	  accept_one_side(friend, user, accepted_at)
  	end
  end

  # Delete a friendship or cancel a pending request
  # Not sure if correct, see Listing 14.4
  def self.breakup(user, friend)
  	transaction do
  	  find_by(user: user, friend: friend).destroy
  	  find_by(user: friend, friend: user).destroy
  	end
  end

  private

  # Update the db with one side of an accepted friendship request

  def self.accept_one_side(user, friend, accepted_at)
  	request = find_by(user: user, friend: friend)
  	request.status = 'accepted'
  	request.accepted_at = accepted_at
  	request.save!
  end

end
