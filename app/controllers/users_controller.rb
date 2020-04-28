class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :user_signed_in? 
  before_action :set_user, only: %i(show)
  
  def show
  end
end
