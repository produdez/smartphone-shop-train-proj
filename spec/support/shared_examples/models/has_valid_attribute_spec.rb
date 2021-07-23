# frozen_string_literal: true

RSpec.shared_examples 'has valid attributes' do
  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end
end
