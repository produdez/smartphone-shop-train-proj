class OperatingSystemsController < ApplicationController
  load_and_authorize_resource

  def index
    @operating_systems = @operating_systems.order(updated_at: :desc).page(params[:page])
  end

  def new; end

  def create
    OperatingSystem.create!(operating_system_params)
    flash[:success] = 'Created OS successfully!'
    redirect_to operating_systems_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Fail to create OS!'
    redirect_to new_operating_system_path
  end

  def edit; end

  def update
    @operating_system.update!(operating_system_params)
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

  def operating_system_params
    params.require(:operating_system).permit(:name)
  end
end
