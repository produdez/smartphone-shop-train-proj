# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Users', type: :request do # rubocop:todo Metrics/BlockLength
  let(:employee) { create(:staff, role: 'employee') }
  let(:user) { employee.user }

  before(:example, :logged_in) do
    sign_in user
  end

  describe 'GET /users' do
    subject { get users_url }
    context 'Logged In', :logged_in do
      it_behaves_like 'url responds ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /user/current_user:id' do
    subject { get user_url(user) }
    context 'Logged In', :logged_in do
      it_behaves_like 'url responds ok'
    end

    it_behaves_like 'not logged in'
  end

  context 'Admin Only' do
    let(:user) { create(:user, role: 'admin') }

    describe 'GET /users/new_manager' do
      subject { get new_manager_users_url }
      context 'Logged In', :logged_in do
        it_behaves_like 'url responds ok'
      end

      it_behaves_like 'not logged in'
    end

    describe 'POST /users/create_manager' do
      let(:params) { manager_params }
      subject { post create_manager_users_url, params: params }
      context 'Logged In', :logged_in do
        it 'create manager and routes back to new index' do
          expect do
            subject
          end.to change(User, :count).by(1)
          expect(response).to redirect_to(new_manager_users_url)
          expect(User.last).to eql_manager_params(params)
        end
      end

      it_behaves_like 'not logged in'
    end
  end

  context 'Manager Only' do
    let(:manager) { create(:staff, role: 'manager') }
    let(:user) { manager.user }

    describe 'GET /users/new_employee' do
      subject { get new_employee_users_url }
      context 'Logged In', :logged_in do
        it_behaves_like 'url responds ok'
      end

      it_behaves_like 'not logged in'
    end

    describe 'POST /users/create_employee' do
      let(:params) { employee_params }
      subject { post create_employee_users_url, params: params }
      context 'Logged In', :logged_in do
        it 'create manager and routes back to new index' do
          expect do
            subject
          end.to change(User, :count).by(1)
          expect(response).to redirect_to(new_employee_users_url)
          expect(User.last).to eql_employee_params(params, 'user', 'employee')
          expect(User.last.staff.store_id).to eql(manager.store_id)
        end
      end

      it_behaves_like 'not logged in'
    end
  end
end
