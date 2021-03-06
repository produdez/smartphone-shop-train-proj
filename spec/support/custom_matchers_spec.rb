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

RSpec::Matchers.define :eql_phone_params do |params|
  match do |phone|
    p = params[:phone]
    phone.model.id == p[:model_id] && phone.color.id == p[:color_id] \
    && phone.manufacture_year == p[:manufacture_year] && phone.condition == p[:condition] \
    && phone.memory == p[:memory] && phone.price == p[:price] \
    && phone.status == p[:status]
  end
end

RSpec::Matchers.define :eql_manager_params do |params|
  match do |user|
    p = params[:user]
    staff = user.staff
    user.email == p[:email] && user.name == p[:user_name] && user.role == 'user' \
    && staff.store.name == p[:store_name] && staff.store.location == p[:store_location] \
    && staff.role == 'manager'
  end
end

RSpec::Matchers.define :eql_employee_params do |params|
  match do |user|
    p = params[:user]
    staff = user.staff
    user.email == p[:email] && user.name == p[:user_name] && user.role == 'user' \
    && staff.role == 'employee'
  end
end
