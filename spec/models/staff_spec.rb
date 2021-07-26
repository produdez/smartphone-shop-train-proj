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

  include_examples 'has valid attributes'

  context 'must have valid user account' do
    include_examples 'must have field', 'user'
    include_examples 'reference field', 'user'
    it 'invalid staff\s user account is admin' do
      subject.user = create(:user, role: 'admin')
      expect(subject).to_not be_valid
    end
  end

  context 'must have valid store' do
    include_examples 'must have field', 'user'
    include_examples 'reference field', 'store'
    it 'invalid if more than one manager per store' do
      existing_manager = create(:staff, role: 'manager')
      subject.store = existing_manager.store
      expect(subject).to_not be_valid
    end
  end

  context 'must have valid role' do
    include_examples 'presence field', 'role'
    include_examples 'defaulted field', 'role', 'employee'
    include_examples 'inclusion field', 'role', 'fake role'
  end
end
