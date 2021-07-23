# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject do
    described_class.new(name: 'Test Brand')
  end

  include_examples 'has valid attributes'

  include_examples 'presence field', 'name'

  include_examples 'unique field', :brand, 'name', 'Dup Name'
end
