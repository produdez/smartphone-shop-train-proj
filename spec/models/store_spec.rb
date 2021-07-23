# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  subject do
    described_class.new(name: 'Test Store')
  end

  include_examples 'has valid attributes'

  include_examples 'presence field', 'name'

  include_examples 'unique field', :store, 'name', 'Dup Name'
end
