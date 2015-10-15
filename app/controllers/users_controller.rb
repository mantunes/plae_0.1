class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user 
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end
end
