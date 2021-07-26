# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Color, type: :model do
  subject do
    described_class.new(name: 'Test Color')
  end

  include_examples 'has valid attributes'

  include_examples 'presence field', 'name'

  include_examples 'unique field', :color, 'name', 'Dup Name'
end
