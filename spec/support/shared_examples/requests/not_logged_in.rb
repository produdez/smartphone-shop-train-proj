# frozen_string_literal: true

RSpec.shared_examples 'not logged in' do
  context 'not logged in' do
    it 'redirect to login' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
