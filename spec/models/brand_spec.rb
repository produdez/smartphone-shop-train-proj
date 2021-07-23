# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject do
    described_class.new(name: 'Test Brand')
  end

  it_behaves_like 'has valid attributes'

  it_behaves_like 'presence field', 'name'

  it_behaves_like 'unique field', :brand, 'name', 'Dup Name'
end
