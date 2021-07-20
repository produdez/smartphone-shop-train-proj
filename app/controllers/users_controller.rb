# frozen_string_literal: true

class UsersController < ApplicationController # rubocop:todo Style/Documentation
  authorize_resource

  class PasswordConfirmationMismatch < StandardError # rubocop:todo Style/Documentation
    def message
      'Confirmation password mismatch!'
    end
  end

  def show; end

  def new_manager; end

  def create_manager
    ActiveRecord::Base.transaction do
      raise PasswordConfirmationMismatch if password_mismatch

      try_create_user('manager')
      flash[:success] = 'Created Manager!'
    rescue PasswordConfirmationMismatch => e
      flash[:error] = e
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Error creating user: #{e.message}"
    ensure
      redirect_to(new_manager_users_path)
    end
  end

  private

  def permited_params
    params.require(:user).permit(:store_name, :manager_name, :email, :password,
                                 :password_confirmation, :store_location, :phone)
  end

  def user_params(param)
    { name: param[:manager_name], email: param[:email], password: param[:password] }
  end

  def store_params(param)
    { name: param[:store_name], location: param[:store_location] }
  end

  def password_mismatch
    permited_params[:password] != permited_params[:password_confirmation]
  end

  def try_create_user(role)
    user = User.create!(user_params(permited_params))
    store = Store.create!(store_params(permited_params))
    Staff.create!(user: user, store: store, role: role)
  end
end
