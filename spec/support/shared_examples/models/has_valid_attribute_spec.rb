# frozen_string_literal: true

RSpec.shared_examples 'has valid attributes' do
  it 'should be valid' do
    expect(subject).to be_valid
  end
end
