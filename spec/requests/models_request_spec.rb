# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'OperatingSystems', type: :request do # rubocop:todo Metrics/BlockLength
  let(:admin) { create(:user, role: 'admin', email: 'admin@admin.com') }

  before(:example, :logged_in) do
    sign_in admin
  end

  describe 'GET /models' do
    subject { get models_url }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /models/new' do
    subject { get new_model_url }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'POST /models/new' do
    let(:params) { model_params('New Test Model') }

    subject { post models_url, params: params }
    context 'Logged In', :logged_in do
      it 'should create correcly and redirect to index' do
        expect { subject }.to change(Model, :count).by(1)
        expect(response).to redirect_to(models_url)
        expect(Model.first).to eql_model_params(params)
      end
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /models/:id/edit' do
    let(:model) { create(:model) }
    subject { get edit_model_url(model) }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'PATCH /models/:id' do
    let(:model) { create(:model) }
    let(:params) { model_params('Updated Model') }
    subject { patch model_url(model), params: params }

    context 'Logged In', :logged_in do
      it 'should edit correctly and redirect to edit' do
        subject
        expect(response).to redirect_to(models_url)
        expect(Model.first).to eql_model_params(params)
      end
    end

    it_behaves_like 'not logged in'
  end
end
