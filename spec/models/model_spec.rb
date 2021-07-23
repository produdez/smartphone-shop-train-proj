# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Model, type: :model do
  subject do
    brand = create(:brand)
    os = create(:operating_system)
    described_class.new(name: 'Test Model', brand: brand, operating_system: os)
  end

  it_behaves_like 'has valid attributes'

  context 'Must have valid Name' do
    it_behaves_like 'presence field', 'name'
    it_behaves_like 'unique field', :model, 'name', 'Dup Name'
  end

  context 'Must have valid brand' do
    it_behaves_like 'must have field', 'brand'
    it_behaves_like 'reference field', 'brand'
  end

  context 'Must have valid operating system' do
    it_behaves_like 'must have field', 'operating_system'
    it_behaves_like 'reference field', 'operating_system'
  end
end
