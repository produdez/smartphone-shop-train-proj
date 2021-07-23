# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff, type: :model do # rubocop:todo Metrics/BlockLength
  subject do
    described_class.new(
      user: create(:user),
      store: create(:store),
      role: 'manager'
    )
  end

  it_behaves_like 'has valid attributes'

  context 'Must have valid user account' do
    it_behaves_like 'must have field', 'user'
    it_behaves_like 'reference field', 'user'
    it 'invalid staff\s user account is admin' do
      subject.user = create(:user, role: 'admin')
      expect(subject).to_not be_valid
    end
  end

  context 'Must have valid store' do
    it_behaves_like 'must have field', 'user'
    it_behaves_like 'reference field', 'store'
    it 'invalid if more than one manager per store' do
      existing_manager = create(:staff, role: 'manager')
      subject.store = existing_manager.store
      expect(subject).to_not be_valid
    end
  end

  context 'Must have valid role' do
    it_behaves_like 'presence field', 'role'
    it_behaves_like 'defaulted field', 'role', 'employee'
    it_behaves_like 'inclusion field', 'role', 'fake role'
  end
end
