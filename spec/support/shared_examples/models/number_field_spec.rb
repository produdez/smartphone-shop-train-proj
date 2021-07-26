# frozen_string_literal: true

RSpec.shared_examples 'number field' do |field_name|
  it 'is invalid with non number value' do
    subject.send("#{field_name}=", 'string')
    expect(subject).to_not be_valid
  end
end
