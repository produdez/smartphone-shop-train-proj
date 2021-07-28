# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OperatingSystems', type: :request do # rubocop:todo Metrics/BlockLength
  let(:user) { create(:user, role: 'admin', email: 'admin@admin.com') }

  describe 'GET /operating_systems' do
    subject { get operating_systems_url }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    context 'when user is not admin' do
      let(:staff) { create(:staff) }
      let(:user) { staff.user }

      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end
  end

  shared_examples 'when user is not admin' do
    context 'when user is not admin' do
      let(:staff) { create(:staff) }
      let(:user) { staff.user }
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'GET /operating_systems/new' do
    subject { get new_operating_system_url }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'POST /operating_systems' do
    let(:params) { { operating_system: attributes_for(:operating_system) } }
    subject { post operating_systems_url, params: params }

    context 'when user is admin' do
      context 'with valid params' do
        before { sign_in user }

        it 'add new record and redirect to index' do
          expect { subject }.to change(OperatingSystem, :count).by(1)
          expect(response).to redirect_to(operating_systems_url)
          expect(OperatingSystem.first).to eql_os_params(params)
        end
      end

      context 'with invalid params' do
        before { sign_in user }

        it 'do not create record, redirect to new' do
          params[:operating_system][:name] = ' '
          expect { subject }.to change(OperatingSystem, :count).by(0)
          expect(response).to redirect_to(new_operating_system_url)
        end
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'GET /operating_system/:id/edit' do
    let(:operating_system) { create(:operating_system) }
    subject { get edit_operating_system_url(operating_system) }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'patch /operating_systems/:id' do # rubocop:todo Metrics/BlockLength
    let(:operating_system) { create(:operating_system) }
    let(:params) { { operating_system: attributes_for(:operating_system, name: 'Updated OperatingSystem') } }
    subject { patch operating_system_url(operating_system), params: params }

    context 'when user is admin' do
      context 'with valid params' do
        before { sign_in user }

        it 'update record and redirect to index' do
          subject
          expect(response).to redirect_to(operating_systems_url)
          created_operating_system = OperatingSystem.first
          expect(created_operating_system).to eql_os_params(params)
          expect(created_operating_system.id).to eql(operating_system.id)
        end
      end

      context 'with invalid params' do
        before { sign_in user }

        it 'do not change record, redirect to edit' do
          params[:operating_system][:name] = ' '
          subject
          expect(operating_system.name).to_not eql(params[:operating_system][:name])
          expect(response).to redirect_to(edit_operating_system_url(operating_system))
        end
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'delete /operating_systems/:id' do
    let(:operating_systems) { create_list(:operating_system, 3) }
    let(:delete_operating_system) { operating_systems.last }
    subject { delete operating_system_url(delete_operating_system) }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        it 'delete and redirect to index' do
          expect { operating_systems }.to change(OperatingSystem, :count).by(3)
          expect { subject }.to change(OperatingSystem, :count).by(-1)
          expect(response).to redirect_to(operating_systems_url)
          expect(OperatingSystem.where(id: delete_operating_system.id)).not_to exist
        end
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end
end
