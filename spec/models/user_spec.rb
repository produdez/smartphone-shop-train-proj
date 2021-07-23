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

  include_examples 'has valid attributes'

  context 'Must have valid email' do
    include_examples 'presence field', 'email'
    include_examples 'unique field', :user, 'email', 'dup@email.com'
    it 'is invalid with wrong format' do
      subject.email = 'notmail'
      expect(subject).to_not be_valid
    end
  end

  context 'Must have valid password' do
    include_examples 'presence field', 'password'
    it 'is invalid if too short' do
      subject.email = '123'
      expect(subject).to_not be_valid
    end
  end

  context 'Must have valid name' do
    include_examples 'presence field', 'name'
  end

  context 'Must have valid role' do
    include_examples 'presence field', 'role'
    include_examples 'defaulted field', 'role', 'user'
    include_examples 'inclusion field', 'role', 'fake role'
  end

  context 'Must have valid phone number' # TODO: add this and check phone format (can be null, empty)
end
