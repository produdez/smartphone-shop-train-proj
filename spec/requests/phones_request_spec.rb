# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Phones', type: :request do # rubocop:todo Metrics/BlockLength
  let(:employee) { create(:staff) }
  let(:store) { employee.store }
  let(:user) { employee.user }

  describe 'GET /phones' do
    subject { get phones_url }

    context 'when logged in' do
      before { sign_in user }

      include_examples 'url responds ok'
    end

    include_examples 'not logged in'
  end

  describe 'GET /phones/:id' do
    let(:phone) { create(:phone, store: store) }
    subject { get phone_url(phone) }

    context 'when logged in' do
      before { sign_in user }

      include_examples 'url responds ok'
    end

    include_examples 'not logged in'
  end

  describe 'GET /phones/:id/edit' do
    let(:phone) { create(:phone, store: store) }
    subject { get edit_phone_url(phone) }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'PATCH /phones/:id' do # rubocop:todo Metrics/BlockLength
    let(:phone) { create(:phone, store: store) }
    let(:params) { phone_params(quantity: nil) }
    subject { patch phone_url(phone), params: params }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'with valid params' do
        before { sign_in user }

        it 'update record and redirect to show' do
          subject
          expect(response).to redirect_to(phone_url(phone))
          expect(Phone.first).to eql_phone_params(params)
        end
      end

      context 'with invalid params' do
        before do
          sign_in user
          params[:phone][:memory] = -5
        end

        it 'do not change record, redirect to edit' do
          subject
          expect(phone.memory).to_not eql(params[:phone][:memory])
          expect(response).to redirect_to(edit_phone_url(phone))
        end
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'DELETE /phones/:id' do
    let(:phones) { create_list(:phone, 5, store: store) }
    let(:delete_phone) { phones.last }
    subject { delete phone_url(delete_phone) }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'when logged in' do
        before { sign_in user }

        it 'delete and redirect to index' do
          expect { phones }.to change(Phone, :count).by(5)
          expect { subject }.to change(Phone, :count).by(-1)
          expect(response).to redirect_to(phones_url)
          expect(Phone.where(id: delete_phone.id)).not_to exist
        end
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'POST /phones/delete_selected' do
    let(:phones) { create_list(:phone, 5, store: store) }
    let(:ids) { phones.last(2).pluck(:id) }
    let(:params) { { ids: ids.join(',') } }
    subject { post delete_selected_phones_url, params: params }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'when logged in' do
        before { sign_in user }

        it 'delete all selected and ok respond (ajax response)' do
          expect { phones }.to change(Phone, :count).by(5)
          expect { subject }.to change(Phone, :count).by(-2)
          expect(response).to have_http_status(:ok)
          expect(Phone.where(id: ids)).not_to exist
        end
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'POST /phones/set_unavailable_selected' do
    let(:phones) { create_list(:phone, 5, store: store) }
    let(:ids) { phones.first(2).pluck(:id) }
    let(:params) { { ids: ids.join(',') } }
    subject { post set_unavailable_selected_phones_url, params: params }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'when logged in' do
        before { sign_in user }

        it 'set unavailable all selected and ok respond (ajax response)' do
          expect { phones }.to change(Phone, :count).by(5)
          subject
          expect(response).to have_http_status(:ok)
          expect(Phone.unavailable.pluck(:id)).to eql(ids)
        end
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'GET /phones/new' do
    subject { get new_phone_url }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end

  describe 'POST /phones' do # rubocop:todo Metrics/BlockLength
    let(:params) { phone_params(quantity: 3) }

    subject { post phones_url, params: params }

    context 'when user is manager' do
      let(:manager) { create(:staff, role: 'manager', store: store) }
      let(:user) { manager.user }

      context 'with valid params' do
        before { sign_in user }

        it 'add new record and redirect to index' do
          expect { subject }.to change(Phone, :count).by(3)
          expect(response).to redirect_to(phones_url)
          expect(Phone.first).to eql_phone_params(params)
          expect(Phone.first.store).to eql(store)
        end
      end

      context 'with invalid params' do
        before { sign_in user }

        it 'do not create record, redirect to new' do
          params[:phone][:memory] = -1
          expect { subject }.to change(Phone, :count).by(0)
          expect(response).to redirect_to(new_phone_url)
        end
      end

      include_examples 'not logged in'
    end

    context 'when user is not manager' do
      before { sign_in user }

      include_examples 'not authorized'
    end
  end
end
