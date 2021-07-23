# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Color, type: :model do
  subject do
    described_class.new(name: 'Test Color')
  end

  it_behaves_like 'has valid attributes'

  it_behaves_like 'presence field', 'name'

  it_behaves_like 'unique field', :color, 'name', 'Dup Name'
end
