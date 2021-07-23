# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperatingSystem, type: :model do
  subject do
    described_class.new(name: 'Test OS')
  end

  include_examples 'has valid attributes'

  include_examples 'presence field', 'name'

  include_examples 'unique field', :operating_system, 'name', 'Dup Name'
end
