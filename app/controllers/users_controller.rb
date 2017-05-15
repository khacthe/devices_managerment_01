class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    return if current_user == @user
    flash[:alert] = t "users.please_login"
    redirect_to root_path
  end
end
