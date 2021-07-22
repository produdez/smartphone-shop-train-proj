# frozen_string_literal: true

RSpec.shared_examples 'not_logged_in' do
  it 'should redirect to login' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end
end
