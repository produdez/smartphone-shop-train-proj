# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :eql_brand_params do |params|
  match do |brand|
    brand.name == params[:brand][:name]
  end
end

RSpec::Matchers.define :eql_os_params do |params|
  match do |os|
    os.name == params[:operating_system][:name]
  end
end

RSpec::Matchers.define :eql_model_params do |params|
  match do |model|
    p = params[:model]
    model.name == p[:name] \
    && model.brand.id == p[:brand_id] \
    && model.operating_system.id == p[:operating_system_id]
  end
end
