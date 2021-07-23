# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  subject do
    described_class.new(name: 'Test Store')
  end

  it_behaves_like 'has valid attributes'

  it_behaves_like 'presence field', 'name'

  it_behaves_like 'unique field', :store, 'name', 'Dup Name'
end
