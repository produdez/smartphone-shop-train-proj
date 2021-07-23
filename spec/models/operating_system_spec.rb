# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperatingSystem, type: :model do
  subject do
    described_class.new(name: 'Test OS')
  end

  it_behaves_like 'has valid attributes'

  it_behaves_like 'presence field', 'name'

  it_behaves_like 'unique field', :operating_system, 'name', 'Dup Name'
end
