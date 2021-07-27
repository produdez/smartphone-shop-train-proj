# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Models', type: :request do # rubocop:todo Metrics/BlockLength
  before(:example, :logged_in) do
    sign_in user
  end

  shared_context 'when user is any role' do
    describe 'GET /models' do
      subject { get models_url }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end
  end

  shared_examples 'when user is not admin', :logged_in do
    describe 'GET /models/new' do
      subject { get new_model_url }
      include_examples 'not authorized'
    end

    describe 'POST /models/' do
      let(:params) { { model: attributes_for(:model) } }
      subject { post models_url, params: params }
      include_examples 'not authorized'
    end

    describe 'GET /models/:id/edit' do
      let(:model) { create(:model) }
      subject { get edit_model_url(model) }
      include_examples 'not authorized'
    end

    describe 'PATCH /models/:id/' do
      let(:model) { create(:model) }
      subject { patch model_url(model), params: {} }
      include_examples 'not authorized'
    end

    describe 'DELETE /models/:id/' do
      let(:models) { create_list(:model, 3) }
      let(:delete_model) { models.last }
      subject { delete model_url(delete_model) }
      include_examples 'not authorized'
    end
  end

  context 'when user is employee' do
    let(:staff) { create(:staff) }
    let(:user) { staff.user }

    include_context 'when user is any role'

    context 'when access unauthorized' do
      include_examples 'when user is not admin'
    end
  end

  context 'when user is manager' do
    let(:staff) { create(:staff) }
    let(:user) { staff.user }

    include_context 'when user is any role'

    context 'when access unauthorized' do
      include_examples 'when user is not admin'
    end
  end

  context 'when user is admin' do # rubocop:todo Metrics/BlockLength
    let(:user) { create(:user, role: 'admin', email: 'admin@admin.com') }

    include_context 'when user is any role'

    describe 'GET /models/new' do
      subject { get new_model_url }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /models/new' do
      let(:params) { model_params('New Test Model') }

      subject { post models_url, params: params }
      context 'logged in', :logged_in do
        it 'valid params, create and redirect to index' do
          expect { subject }.to change(Model, :count).by(1)
          expect(response).to redirect_to(models_url)
          expect(Model.first).to eql_model_params(params)
        end

        it 'invalid params, no create, redirect to new' do
          params[:model][:name] = ' '
          expect { subject }.to change(Model, :count).by(0)
          expect(response).to redirect_to(new_model_url)
        end
      end

      include_examples 'not logged in'
    end

    describe 'GET /models/:id/edit' do
      let(:model) { create(:model) }
      subject { get edit_model_url(model) }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'PATCH /models/:id' do
      let(:model) { create(:model) }
      let(:params) { model_params('Updated Model') }
      subject { patch model_url(model), params: params }

      context 'logged in', :logged_in do
        it 'valid params, edit and redirect to edit' do
          subject
          expect(response).to redirect_to(models_url)
          expect(Model.first).to eql_model_params(params)
        end

        it 'invalid params, no change, redirect to edit' do
          params[:model][:name] = ' '
          subject
          expect(model.name).to_not eql(params[:model][:name])
          expect(response).to redirect_to(edit_model_url(model))
        end
      end

      include_examples 'not logged in'
    end

    describe 'DELETE /models/:id' do
      let(:models) { create_list(:model, 3) }
      let(:delete_model) { models.last }
      subject { delete model_url(delete_model) }

      context 'logged in', :logged_in do
        it 'delete and redirect to index' do
          expect { models }.to change(Model, :count).by(3)
          expect { subject }.to change(Model, :count).by(-1)
          expect(response).to redirect_to(models_url)
          expect(Model.where(id: delete_model.id)).not_to exist
        end
      end

      include_examples 'not logged in'
    end
  end
end
