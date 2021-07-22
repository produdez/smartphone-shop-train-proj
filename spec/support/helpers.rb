# frozen_string_literal: true

module Helpers
  def model_params(name)
    brand = create(:brand)
    os = create(:operating_system)
    { model: { name: name, operating_system_id: os.id, brand_id: brand.id } }
  end

  def phone_params(quantity: 2)
    model = create(:model)
    color = create(:color)
    params = { phone: { manufacture_year: 2010, condition: 'percent99', memory: 690,
                        price: BigDecimal('897.66'), status: 'unavailable',
                        model_id: model.id, color_id: color.id } }
    params[:phone].merge!({ quantity: quantity }) if quantity.present?
    params
  end
end
