# frozen_string_literal: true

RSpec.shared_examples 'not authorized' do
  it 'not authorized' do
    expect { subject }.to raise_error(CanCan::AccessDenied)
  end
end
