# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OperatingSystems', type: :request do # rubocop:todo Metrics/BlockLength
  let(:admin) { create(:user, role: 'admin', email: 'admin@admin.com') }

  before(:example, :logged_in) do
    sign_in admin
  end

  describe 'GET /operating_systems' do
    subject { get operating_systems_url }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /operating_systems/new' do
    subject { get new_operating_system_url }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'POST /operating_systems/' do
    let(:params) { { operating_system: attributes_for(:operating_system) } }
    subject { post operating_systems_url, params: params }

    context 'Logged In', :logged_in do
      it 'should add new record and redirect' do
        expect { subject }.to change(OperatingSystem, :count).by(1)
        expect(response).to redirect_to(operating_systems_url)
        expect(OperatingSystem.first).to eql_os_params(params)
      end
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /operating_system/:id/edit' do
    let(:operating_system) { create(:operating_system) }
    subject { get edit_operating_system_url(operating_system) }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'patch /operating_systems/:id/' do
    let(:operating_system) { create(:operating_system) }
    let(:params) { { operating_system: attributes_for(:operating_system, name: 'Updated OS') } }
    subject { patch operating_system_url(operating_system), params: params }

    context 'Logged In', :logged_in do
      it 'should return edit and redirect' do
        subject
        expect(response).to redirect_to(operating_systems_url)
        created_operating_system = OperatingSystem.first
        expect(created_operating_system).to eql_os_params(params)
        expect(created_operating_system.id).to eql(operating_system.id)
      end
    end

    it_behaves_like 'not logged in'
  end

  describe 'delete /operating_systems/:id' do
    let(:operating_systems) { create_list(:operating_system, 3) }
    let(:delete_operating_system) { operating_systems.last }
    subject { delete operating_system_url(delete_operating_system) }

    context 'Logged In', :logged_in do
      it 'should return delete and redirect' do
        expect { operating_systems }.to change(OperatingSystem, :count).by(3)
        expect { subject }.to change(OperatingSystem, :count).by(-1)
        expect(response).to redirect_to(operating_systems_url)
        expect(OperatingSystem.where(id: delete_operating_system.id)).not_to exist
      end
    end

    it_behaves_like 'not logged in'
  end
end
