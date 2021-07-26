# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Model, type: :model do
  subject do
    brand = create(:brand)
    os = create(:operating_system)
    described_class.new(name: 'Test Model', brand: brand, operating_system: os)
  end

  include_examples 'has valid attributes'

  context 'must have valid Name' do
    include_examples 'presence field', 'name'
    include_examples 'unique field', :model, 'name', 'Dup Name'
  end

  context 'must have valid brand' do
    include_examples 'must have field', 'brand'
    include_examples 'reference field', 'brand'
  end

  context 'must have valid operating system' do
    include_examples 'must have field', 'operating_system'
    include_examples 'reference field', 'operating_system'
  end
end
