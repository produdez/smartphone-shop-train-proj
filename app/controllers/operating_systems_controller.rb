class OperatingSystemsController < ApplicationController
  before_action :load_os, only: %i[edit update destroy show]
  def index
    @operating_systems = OperatingSystem.order(updated_at: :desc)
  end

  def new; end

  def create
    OperatingSystem.create!(os_params)
    flash[:success] = 'Created OS successfully!'
    redirect_to operating_systems_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to create OS!'
    redirect_to new_operating_system_path
  end

  def edit; end

  def update
    @operating_system.update!(os_params)
    flash[:success] = 'Updated OS successfully!'
    redirect_to operating_systems_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to update OS!'
    redirect_to edit_operating_system_path(@operating_system)
  end

  def destroy
    @operating_system.destroy!
    flash[:success] = 'Deleted OS successfully'
    redirect_to(operating_systems_path)
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = 'Fail to delete seleted OS!'
    redirect_to(operating_system_path(@operating_system))
  end

  private

  def os_params
    params.require(:operating_system).permit(:name)
  end

  def load_os
    @operating_system = OperatingSystem.find(params[:id])
  end
end