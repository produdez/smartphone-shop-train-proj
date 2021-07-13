class PhonesController < ApplicationController
  def index
    @phones = Phone.all
  end

  def new
    @models = Model.all
    @phone = Phone.new
  end

  def create
    p = params
    puts 'Phone: ', p
    model = Model.find_by(name: p[:model])
    color = Color.find_by(name: p[:color])
    condition = helpers.get_condition_value(p[:condition])

    phone = Phone.new(
      model: model, color: color,
      
      memory: p[:memory], condition: condition, 
      price: p[:price], note: p[:note]
    )

    #! loop quantity

    puts phone.inspect
  end
end
