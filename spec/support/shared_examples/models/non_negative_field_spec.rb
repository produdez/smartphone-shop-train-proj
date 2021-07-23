# frozen_string_literal: true

RSpec.shared_examples 'non negative field' do |field_name|
  it 'should be invalid with negative' do
    subject.send("#{field_name}=", -5)
    expect(subject).to_not be_valid
  end
end
