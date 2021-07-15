class PhonesController < ApplicationController
  def index
    @phones = Phone.all
  end

  def new; end

  def create
    batch_size = params[:phone][:quantity].to_i
    idx = 1
    phone = nil
    while idx <= batch_size
      phone = Phone.new(phone_params)
      phone.store_id = 1 # TODO: get store_id from user after auth is implemented
      phone.save!
      idx += 1
    end
    flash[:success] = "Created #{batch_size} phones successfully (finished: #{Time.now})"
    redirect_to(phones_path)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Error creating phones, batch_size: #{batch_size}, stoped at ##{idx}"

    phone.errors.errors.each do |error|
      flash[:error] << ", (Error Attribute: #{error.attribute}, Type: #{error.type})"
    end
    redirect_to(new_phone_path)
  end

  def show
    @phone = Phone.find(params[:id])
  end

  def edit
    @phone = Phone.find(params[:id])
  end

  def update
    phone = Phone.find(params[:id])
    phone.update!(phone_params)
    flash[:success] = "Edited phone id: #{phone.id} successfully (finished: #{Time.now})"
    redirect_to(phone_path(phone))
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Error editing info of phone id: #{phone.id}"
    phone.errors.errors.each do |error|
      flash[:error] << ", (Attribute: #{error.attribute}, Type: #{error.type})"
    end
    redirect_to(edit_phone_path)
  end

  def destroy
    @phone = Phone.find(params[:id])
    # TODO: Next PR
  end

  private

  def phone_params
    params.require(:phone).permit(:model_id, :memory, :status, :condition, :color_id, :price, :note, :manufacture_year)
  end
end
