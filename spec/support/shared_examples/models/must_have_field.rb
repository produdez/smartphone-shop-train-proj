# frozen_string_literal: true

RSpec.shared_examples 'must have field' do |attribute_name|
  it "is invalid without #{attribute_name}" do
    subject.send("#{attribute_name}=", nil)
    expect(subject).to_not be_valid
  end
end
