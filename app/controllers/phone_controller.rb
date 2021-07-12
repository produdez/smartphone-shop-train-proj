class PhoneController < ApplicationController
  def index
    @phones = Phone.all
  end
end
