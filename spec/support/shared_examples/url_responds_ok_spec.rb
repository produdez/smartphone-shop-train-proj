# frozen_string_literal: true

RSpec.shared_examples 'url_responds_ok' do
  it 'should return ok' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
