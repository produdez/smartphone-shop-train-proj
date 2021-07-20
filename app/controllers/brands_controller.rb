class BrandsController < ApplicationController
  before_action :load_brand, only: %i[edit update destroy show]
  def index
    @brands = Brand.order(updated_at: :desc)
  end

  def new; end

  def create
    Brand.create!(brand_params)
    flash[:success] = 'Created Brand successfully!'
    redirect_to brands_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to create Brand!'
    redirect_to new_brand_path
  end

  def edit; end

  def update
    @brand.update!(brand_params)
    flash[:success] = 'Updated Brand successfully!'
    redirect_to brands_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to update Brand!'
    redirect_to edit_brand_path(@brand)
  end

  def destroy
    @brand.destroy!
    flash[:success] = 'Deleted brand successfully'
    redirect_to(brands_path)
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = 'Fail to delete seleted brand!'
    redirect_to(brand_path(@brand))
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end

  def load_brand
    @brand = Brand.find(params[:id])
  end
end
