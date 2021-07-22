# frozen_string_literal: true

module Helpers
  def model_params(name)
    brand = create(:brand)
    os = create(:operating_system)
    { model: { name: name, operating_system_id: os.id, brand_id: brand.id } }
  end
end
