# frozen_string_literal: true

RSpec.shared_examples 'presence field' do |field_name|
  it 'is not valid if blank' do
    subject.send("#{field_name}=", nil)
    expect(subject).to_not be_valid
    subject.send("#{field_name}=", '')
    expect(subject).to_not be_valid
    subject.send("#{field_name}=", '  ')
    expect(subject).to_not be_valid
    subject.send("#{field_name}=", "\n\t")
    expect(subject).to_not be_valid
  end
end
