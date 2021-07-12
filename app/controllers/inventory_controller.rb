class InventoryController < ApplicationController
  def index
    @phones = Phone.all
  end
end
