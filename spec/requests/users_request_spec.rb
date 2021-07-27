# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Users', type: :request do # rubocop:todo Metrics/BlockLength
  before(:example, :logged_in) do
    sign_in user
  end

  shared_context 'when user is any role' do
    describe 'GET /users' do
      subject { get users_url }
      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'GET /user/:id (self)' do
      subject { get user_url(user) }
      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end
  end

  RSpec.shared_examples 'cant create manager' do
    describe 'GET /users/new_manager' do
      subject { get new_manager_users_url }
      include_examples 'not authorized'
    end

    describe 'POST /users/create_manager' do
      subject { post create_manager_users_url, params: {} }
      include_examples 'not authorized'
    end
  end

  shared_examples 'cant create employee' do
    describe 'GET /users/new_employee' do
      subject { get new_employee_users_url }
      include_examples 'not authorized'
    end

    describe 'POST /users/create_employee' do
      subject { post create_employee_users_url, params: {} }
      include_examples 'not authorized'
    end
  end

  context 'when user is employee' do
    let(:employee) { create(:staff, role: 'employee') }
    let(:user) { employee.user }

    include_context 'when user is any role'

    context 'when access unauthorized urls', :logged_in do
      describe 'GET users/:id (others)' do
        let(:other_employee) { create(:staff) }
        subject { get user_url(other_employee.user) }
        include_examples 'not authorized'
      end

      include_examples 'cant create manager'

      include_examples 'cant create employee'
    end
  end

  context 'when user is admin' do # rubocop:todo Metrics/BlockLength
    let(:user) { create(:user, role: 'admin') }

    include_context 'when user is any role'

    describe 'GET users/:id (others)', :logged_in do
      subject { get user_url(other.user) }
      context 'employee profile' do
        let(:other) { create(:staff) }
        include_examples 'url responds ok'
      end
      context 'employee profile' do
        let(:other) { create(:staff, role: 'manager') }
        include_examples 'url responds ok'
      end
    end

    describe 'GET /users/new_manager' do
      subject { get new_manager_users_url }
      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /users/create_manager' do
      let(:params) { manager_params }
      subject { post create_manager_users_url, params: params }
      context 'logged in', :logged_in do
        it 'invalid params, create manager and routes back to new index' do
          expect { subject }.to change(User, :count).by(1)
          expect(response).to redirect_to(new_manager_users_url)
          expect(User.last).to eql_manager_params(params)
        end

        it 'invalid params, no create, redirect to new' do
          params[:user][:email] = 'notmail'
          expect { subject }.to change(User, :count).by(0)
          expect(response).to redirect_to(new_manager_users_url)
        end
      end

      include_examples 'not logged in'
    end

    context 'when access unauthorized urls', :logged_in do
      include_examples 'cant create employee'
    end
  end

  context 'when user is manager' do # rubocop:todo Metrics/BlockLength
    include_context 'when user is any role'

    let(:manager) { create(:staff, role: 'manager') }
    let(:user) { manager.user }

    describe 'GET /users/new_employee' do
      subject { get new_employee_users_url }
      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /users/create_employee' do
      let(:params) { employee_params }
      subject { post create_employee_users_url, params: params }
      context 'logged in', :logged_in do
        it 'valid params, create manager and routes back to new index' do
          expect { subject }.to change(User, :count).by(1)
          expect(response).to redirect_to(new_employee_users_url)
          expect(User.last).to eql_employee_params(params, 'user', 'employee')
          expect(User.last.staff.store_id).to eql(manager.store_id)
        end

        it 'invalid params, no create, redirect to new' do
          params[:user][:email] = 'notmail'
          expect { subject }.to change(User, :count).by(0)
          expect(response).to redirect_to(new_employee_users_url)
        end
      end

      include_examples 'not logged in'
    end

    context 'when access unauthorized urls', :logged_in do
      include_examples 'cant create manager'
    end
  end
end
