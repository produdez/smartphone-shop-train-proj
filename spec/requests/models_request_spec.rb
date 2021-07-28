# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Models', type: :request do # rubocop:todo Metrics/BlockLength
  let(:user) { create(:user, role: 'admin', email: 'admin@admin.com') }

  shared_context 'login' do
    before { sign_in user }
  end

  describe 'GET /models' do
    subject { get models_url }

    context 'when logged in as admin' do
      include_context 'login'

      include_examples 'url responds ok'
    end

    context 'when user is not admin' do
      let(:staff) { create(:staff) }
      let(:user) { staff.user }
      include_context 'login'

      include_examples 'url responds ok'
    end

    include_examples 'not logged in'
  end

  shared_examples 'when user is not admin' do
    context 'when user is not admin' do
      let(:staff) { create(:staff) }
      let(:user) { staff.user }
      include_context 'login'

      include_examples 'not authorized'
    end
  end

  describe 'GET /models/new' do
    subject { get new_model_url }

    context 'when logged in as admin' do
      include_context 'login'

      include_examples 'url responds ok'
    end

    include_examples 'when user is not admin'

    include_examples 'not logged in'
  end

  describe 'POST /models/' do
    let(:params) { model_params('New Test Model') }
    subject { post models_url, params: params }

    context 'when logged in as admin' do
      include_context 'login'

      context 'with valid params' do
        it 'valid params, add new record and redirect to index' do
          expect { subject }.to change(Model, :count).by(1)
          expect(response).to redirect_to(models_url)
          expect(Model.first).to eql_model_params(params)
        end
      end

      context 'with invalid params' do
        it 'no create, redirect to new' do
          params[:model][:name] = ' '
          expect { subject }.to change(Model, :count).by(0)
          expect(response).to redirect_to(new_model_url)
        end
      end
    end

    include_examples 'when user is not admin'

    include_examples 'not logged in'
  end

  describe 'GET /model/:id/edit' do
    let(:model) { create(:model) }
    subject { get edit_model_url(model) }

    context 'when logged in as admin' do
      include_context 'login'

      include_examples 'url responds ok'
    end

    include_examples 'when user is not admin'

    include_examples 'not logged in'
  end

  describe 'patch /models/:id/' do
    let(:model) { create(:model) }
    let(:params) { model_params('Updated Model') }
    subject { patch model_url(model), params: params }

    context 'when logged in as admin' do
      include_context 'login'

      context 'with valid params' do
        it 'edit and redirect to index' do
          subject
          expect(response).to redirect_to(models_url)
          created_model = Model.first
          expect(created_model).to eql_model_params(params)
          expect(created_model.id).to eql(model.id)
        end
      end

      context 'with invalid params' do
        it 'no change, redirect to edit' do
          params[:model][:name] = ' '
          subject
          expect(model.name).to_not eql(params[:model][:name])
          expect(response).to redirect_to(edit_model_url(model))
        end
      end
    end

    include_examples 'when user is not admin'

    include_examples 'not logged in'
  end

  describe 'delete /models/:id' do
    let(:models) { create_list(:model, 3) }
    let(:delete_model) { models.last }
    subject { delete model_url(delete_model) }

    context 'when logged in as admin' do
      include_context 'login'

      it 'delete and redirect to index' do
        expect { models }.to change(Model, :count).by(3)
        expect { subject }.to change(Model, :count).by(-1)
        expect(response).to redirect_to(models_url)
        expect(Model.where(id: delete_model.id)).not_to exist
      end
    end

    include_examples 'when user is not admin'

    include_examples 'not logged in'
  end
end
