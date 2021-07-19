class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home; end

  def show
    @user = current_user
  end
end
