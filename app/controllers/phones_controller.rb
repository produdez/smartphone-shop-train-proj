class PhonesController < ApplicationController
  before_action :load_phone, only: %i[show edit destroy update]

  def index
    @phones = Phone
    filters = filter_params[:filters].present? ? filter_params[:filters] : {}
    flash[:warning] = 'Filters', filters

    filters.each do |name, options|
      options = options.to_h.symbolize_keys

      next if empty_options(options)

      @phones = @phones.filter_by(name, options)
    end

    @phones = @phones.order(updated_at: :desc)
    flash[:success] = "Filtered: #{@phones.length}"
  end

  def new; end

  def create
    batch_size = params[:phone][:quantity].to_i
    (1..batch_size).each do
      Phone.create!(phone_params.merge(store_id: 2)) # TODO: get store_id from user after auth is implemented
    end
    flash[:success] = "Created #{batch_size} phones successfully (finished: #{Time.now})"
    redirect_to(phones_path)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Error creating phones, batch_size: #{batch_size}"
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
    redirect_to(edit_phone_path)
  end

  def destroy
    @phone.destroy!
    flash[:success] = "Deleted record #{params[:id]} successfully (finished: #{Time.now})"
    redirect_to(phones_path)
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = 'Fail to delete seleted records!'
    redirect_to(phone_path(@phone))
  end

  # NOTE: async ajax
  def delete_selected
    id_list = params[:ids].split(',')
    if id_list.blank?
      render(json: { success: false, error: 'Empty Request' })
      return
    end
    Phone.where(id: id_list).each(&:destroy!)
    message = "Deleted records: #{id_list}, finished: #{Time.now}"
    render(json: { success: true, ids: id_list, total: id_list.length, message: message })
  rescue ActiveRecord::RecordNotDestroyed
    error = 'Fail to delete seleted records!'
    render(json: { success: false, error: error })
  end

  private

  def load_phone
    @phone = Phone.find(params[:id])
  end

  def phone_params
    params.require(:phone).permit(:model_id, :memory, :status, :condition, :color_id, :price, :note, :manufacture_year)
  end

  def filter_params
    # TODO: only permit the needed filters
    params.permit!
  end
end

# TODO: move these helper to helper or module!
def empty_options(options)
  options.reduce(true) { |empty, (_key, val)| empty && val.empty? }
end
