class PhonesController < ApplicationController
  before_action :load_phone, only: %i[show edit destroy update]
  def index
    @phones = Phone.all
  end

  def new; end

  def create
    batch_size = params[:phone][:quantity].to_i
    idx = 1
    phone = nil
    (idx..batch_size).each do
      phone = Phone.new(phone_params)
      phone.store_id = 1 # TODO: get store_id from user after auth is implemented
      phone.save!
    end
    flash[:success] = "Created #{batch_size} phones successfully (finished: #{Time.now})"
    redirect_to(phones_path)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Error creating phones, batch_size: #{batch_size}"
    phone.errors.errors.each do |error|
      flash[:error] << ", (Error Attribute: #{error.attribute}, Type: #{error.type})"
    end
    redirect_to(new_phone_path)
  end

  def show; end

  def edit; end

  def update
    @phone.update!(phone_params)
    flash[:success] = "Edited phone id: #{@phone.id} successfully (finished: #{Time.now})"
    redirect_to(phone_path(@phone))
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Error editing info of phone id: #{@phone.id}"
    @phone.errors.errors.each do |error|
      flash[:error] << ", (Attribute: #{error.attribute}, Type: #{error.type})"
    end
    redirect_to(edit_phone_path)
  end

  def destroy
    # TODO: Next PR
  end

  private

  def load_phone
    @phone = Phone.find(params[:id])
  end

  def phone_params
    params.require(:phone).permit(:model_id, :memory, :status, :condition, :color_id, :price, :note, :manufacture_year)
  end
end
