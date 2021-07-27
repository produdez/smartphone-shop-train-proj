# frozen_string_literal: true

RSpec.shared_examples 'unique field' do |factory, field_name, duplicate_value|
  it "invalid if #{field_name} is duplicated" do
    create(factory, field_name => duplicate_value)
    subject.send("#{field_name}=", duplicate_value)
    expect(subject).to_not be_valid
  end
end
