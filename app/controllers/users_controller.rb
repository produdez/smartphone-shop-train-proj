# frozen_string_literal: true

class UsersController < ApplicationController # rubocop:todo Style/Documentation
  load_and_authorize_resource

  class PasswordConfirmationMismatch < StandardError # rubocop:todo Style/Documentation
    def message
      'Confirmation password mismatch!'
    end
  end

  def index
    @users = @users.includes(:staff).page(params[:page])
  end

  def show; end

  def new_manager; end

  def create_manager # rubocop:todo Metrics/MethodLength
    ActiveRecord::Base.transaction do
      password_missmatch?
      create_user?('manager')
      flash[:success] = 'Created Manager!'
    rescue PasswordConfirmationMismatch => e
      flash[:error] = e.message
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Error creating user: #{e.message}"
    ensure
      redirect_to(new_manager_users_path)
    end
  end

  def new_employee; end

  def create_employee # rubocop:todo Metrics/MethodLength
    ActiveRecord::Base.transaction do
      password_missmatch?
      create_user?('employee')
      flash[:success] = 'Created Employee!'
    rescue PasswordConfirmationMismatch => e
      flash[:error] = e
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Error creating user: #{e.message}"
    ensure
      redirect_to(new_employee_users_path)
    end
  end

  private

  def permited_params
    params.require(:user).permit(:store_name, :user_name, :email, :password,
                                 :password_confirmation, :store_location, :phone)
  end

  def user_params(param)
    { name: param[:user_name], email: param[:email], password: param[:password], phone: param[:phone] }
  end

  def store_params(param)
    { name: param[:store_name], location: param[:store_location] }
  end

  def password_missmatch?
    raise PasswordConfirmationMismatch if permited_params[:password] != permited_params[:password_confirmation]
  end

  def create_user?(role)
    user = User.create!(user_params(permited_params))
    store = role == 'manager' ? Store.create!(store_params(permited_params)) : Store.find(current_user.staff.store_id)
    Staff.create!(user: user, store: store, role: role)
  end
end
