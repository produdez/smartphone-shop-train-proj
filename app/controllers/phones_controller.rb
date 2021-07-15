class PhonesController < ApplicationController
  def index
    @phones = Phone.all
  end

  def new; end

  def create
    batch_size = params[:phone][:quantity].to_i
    begin
      idx = 1
      phone = nil
      while idx <= batch_size
        phone = Phone.new(phone_params)
        phone.store_id = 1 # TODO: get store_id from user after auth is implemented
        phone.save!
        idx += 1
      end
      flash[:success] = "Created #{batch_size} phones successfully (finished: #{Time.now})"
      redirect_to(action: 'index')
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Error creating phones, batch_size: #{batch_size}, error at phone ##{idx}"

      phone.errors.errors.each do |error|
        flash[:error] = "attribute: #{error.attribute}, type: #{error.type}"
      end
      redirect_to(action: 'index')
    end
  end

  # NOTE: async ajax
  def delete_selected
    id_list = params[:ids].split(',')
    phone = nil
    id_list.each do |phone_id|
      phone = Phone.find(phone_id)
      phone.destroy!
    end
    message = "Deleted records: #{id_list}, finished: #{Time.now}"
    render json: { success: true, ids: id_list, total: id_list.length, message: message}
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = "Fail to delete seleted records, stopped at: ##{phone.id}"
    render json: { success: false, error: "Fail to delete seleted records, stopped at: ##{phone.id}" }
  end

  private

  def phone_params
    params.require(:phone).permit(:model_id, :memory, :status, :condition, :color_id, :price, :note, :manufacture_year)
  end
end
