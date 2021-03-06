# frozen_string_literal: true

class BrandsController < ApplicationController # rubocop:todo Style/Documentation
  load_and_authorize_resource

  def index
    @brands = @brands.order(updated_at: :desc).page(params[:page])
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
end
