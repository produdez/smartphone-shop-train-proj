# frozen_string_literal: true

RSpec.shared_examples 'non negative field' do |field_name|
  it 'is invalid with negative value' do
    subject.send("#{field_name}=", -5)
    expect(subject).to_not be_valid
  end
end
