# frozen_string_literal: true

class ModelsController < ApplicationController # rubocop:todo Style/Documentation
  before_action :load_models, only: [:index]
  load_and_authorize_resource

  def index
    @models = @models.order(updated_at: :desc).page(params[:page])
  end

  def create
    Model.create!(model_params)
    flash[:success] = 'Created Model successfully!'
    redirect_to models_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to create Model!'
    redirect_to new_model_path
  end

  def edit; end

  def update
    @model.update!(model_params)
    flash[:success] = 'Updated Model successfully!'
    redirect_to models_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to update Model!'
    redirect_to edit_model_path(@model)
  end

  def destroy
    @model.destroy!
    flash[:success] = 'Deleted model successfully'
    redirect_to(models_path)
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = 'Fail to delete seleted model!'
    redirect_to(model_path(@model))
  end

  private

  def model_params
    params.require(:model).permit(:name, :operating_system_id, :brand_id, :description)
  end

  def load_models
    @models = Model.includes(:brand, :operating_system)
  end
end
