# frozen_string_literal: true

RSpec.shared_examples 'number field' do |field_name|
  it 'should be invalid with non number' do
    subject.send("#{field_name}=", 'string')
    expect(subject).to_not be_valid
  end
end
