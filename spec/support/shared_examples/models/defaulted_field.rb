# frozen_string_literal: true

RSpec.shared_examples 'defaulted field' do |attribute_name, default_value|
  it "is created default with #{attribute_name} = #{default_value}" do
    expect(described_class.new.send(attribute_name)).to eq(default_value)
  end
end
