# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do # rubocop:todo Metrics/BlockLength
  subject do
    described_class.new(
      email: 'test@email.com',
      password: 'testtest123',
      name: 'username',
      phone: '123423945310',
      role: 'admin'
    )
  end

  it_behaves_like 'has valid attributes'

  context 'Must have valid email' do
    it_behaves_like 'presence field', 'email'
    it_behaves_like 'unique field', :user, 'email', 'dup@email.com'
    it 'is invalid with wrong format' do
      subject.email = 'notmail'
      expect(subject).to_not be_valid
    end
  end

  context 'Must have valid password' do
    it_behaves_like 'presence field', 'password'
    it 'is invalid if too short' do
      subject.email = '123'
      expect(subject).to_not be_valid
    end
  end

  context 'Must have valid name' do
    it_behaves_like 'presence field', 'name'
  end

  context 'Must have valid role' do
    it_behaves_like 'presence field', 'role'
    it_behaves_like 'defaulted field', 'role', 'user'
    it_behaves_like 'inclusion field', 'role', 'fake role'
  end

  context 'Must have valid phone number' # TODO: add this and check phone format (can be null, empty)
end
