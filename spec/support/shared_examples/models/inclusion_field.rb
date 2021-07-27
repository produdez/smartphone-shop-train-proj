# frozen_string_literal: true

RSpec.shared_examples 'inclusion field' do |field_name, outside_value|
  it 'invalid if not in inclusion' do
    expect do
      subject.send("#{field_name}=", outside_value)
    end.to raise_error(ArgumentError)
  end
end
