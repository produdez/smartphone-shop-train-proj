# frozen_string_literal: true

RSpec.shared_examples 'reference field' do |reference_field_name|
  it "invalid if #{reference_field_name} is not an existing record" do
    fake_id = subject.send(reference_field_name).id + 1
    subject.send("#{reference_field_name}_id=", fake_id)
    expect(subject).to_not be_valid
  end
end
