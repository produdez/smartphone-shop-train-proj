# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Users', type: :request do # rubocop:todo Metrics/BlockLength
  before(:example, :logged_in) do
    sign_in user
  end

  RSpec.shared_context 'any user' do
    describe 'GET /users' do
      subject { get users_url }
      context 'Logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'GET /user/:id (self)' do
      subject { get user_url(user) }
      context 'Logged in', :logged_in do
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

  RSpec.shared_examples 'cant create employee' do
    describe 'GET /users/new_employee' do
      subject { get new_employee_users_url }
      include_examples 'not authorized'
    end

    describe 'POST /users/create_employee' do
      subject { post create_employee_users_url, params: {} }
      include_examples 'not authorized'
    end
  end

  context 'Current user is employee' do
    let(:employee) { create(:staff, role: 'employee') }
    let(:user) { employee.user }

    include_context 'any user'

    context 'Accesing unauthorized urls', :logged_in do
      describe 'GET users/:id (others)' do
        let(:other_employee) { create(:staff) }
        subject { get user_url(other_employee.user) }
        include_examples 'not authorized'
      end

      include_examples 'cant create manager'

      include_examples 'cant create employee'
    end
  end

  context 'Current user is admin' do # rubocop:todo Metrics/BlockLength
    let(:user) { create(:user, role: 'admin') }

    include_context 'any user'

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
      context 'Logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /users/create_manager' do
      let(:params) { manager_params }
      subject { post create_manager_users_url, params: params }
      context 'Logged in', :logged_in do
        it 'create manager and routes back to new index' do
          expect { subject }.to change(User, :count).by(1)
          expect(response).to redirect_to(new_manager_users_url)
          expect(User.last).to eql_manager_params(params)
        end
      end

      include_examples 'not logged in'
    end

    context 'Accesing unauthorized urls', :logged_in do
      include_examples 'cant create employee'
    end
  end

  context 'Current user is manager' do # rubocop:todo Metrics/BlockLength
    include_context 'any user'

    let(:manager) { create(:staff, role: 'manager') }
    let(:user) { manager.user }

    describe 'GET /users/new_employee' do
      subject { get new_employee_users_url }
      context 'Logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /users/create_employee' do
      let(:params) { employee_params }
      subject { post create_employee_users_url, params: params }
      context 'Logged in', :logged_in do
        it 'create manager and routes back to new index' do
          expect { subject }.to change(User, :count).by(1)
          expect(response).to redirect_to(new_employee_users_url)
          expect(User.last).to eql_employee_params(params, 'user', 'employee')
          expect(User.last.staff.store_id).to eql(manager.store_id)
        end
      end

      include_examples 'not logged in'
    end

    context 'Accesing unauthorized urls', :logged_in do
      include_examples 'cant create manager'
    end
  end
end
