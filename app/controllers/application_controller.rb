# frozen_string_literal: true

class ApplicationController < ActionController::Base # rubocop:todo Style/Documentation
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    phones_path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end
end
