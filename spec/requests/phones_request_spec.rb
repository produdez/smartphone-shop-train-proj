# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Phones', type: :request do # rubocop:todo Metrics/BlockLength
  let(:store) { create(:store) }
  before(:example, :logged_in) do
    sign_in user
  end

  shared_context 'when user is any role' do
    describe 'GET /phones' do
      subject { get phones_url }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'GET /phones/:id/' do
      let(:phone) { create(:phone, store: store) }
      subject { get phone_url(phone) }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end
  end

  shared_context 'when user is manager or admin' do # rubocop:todo Metrics/BlockLength
    describe 'GET /phones/:id/edit' do
      let(:phone) { create(:phone, store: store) }
      subject { get edit_phone_url(phone) }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'PATCH /phones/:id' do
      let(:phone) { create(:phone, store: store) }
      let(:params) { phone_params(quantity: nil) }
      subject { patch phone_url(phone), params: params }

      context 'logged in', :logged_in do
        it 'valid params, edit correctly and redirect to show' do
          subject
          expect(response).to redirect_to(phone_url(phone))
          expect(Phone.first).to eql_phone_params(params)
        end

        it 'invalid params, no change, redirect to edit' do
          params[:phone][:memory] = -5
          subject
          expect(phone.memory).to_not eql(params[:phone][:memory])
          expect(response).to redirect_to(edit_phone_url(phone))
        end
      end

      include_examples 'not logged in'
    end

    describe 'DELETE /phones/:id' do
      let(:phones) { create_list(:phone, 5, store: store) }
      let(:delete_phone) { phones.last }
      subject { delete phone_url(delete_phone) }

      context 'logged in', :logged_in do
        it 'delete and redirect to index' do
          expect { phones }.to change(Phone, :count).by(5)
          expect { subject }.to change(Phone, :count).by(-1)
          expect(response).to redirect_to(phones_url)
          expect(Phone.where(id: delete_phone.id)).not_to exist
        end
      end

      include_examples 'not logged in'
    end

    describe 'POST /phones/delete_selected' do
      let(:phones) { create_list(:phone, 5, store: store) }
      let(:ids) { phones.last(2).pluck(:id) }
      let(:params) { { ids: ids.join(',') } }
      subject { post delete_selected_phones_url, params: params }

      context 'logged in', :logged_in do
        it 'valid params, delete all selected and ok respond (ajax response)' do
          expect { phones }.to change(Phone, :count).by(5)
          expect { subject }.to change(Phone, :count).by(-2)
          expect(response).to have_http_status(:ok)
          expect(Phone.where(id: ids)).not_to exist
        end
      end
    end

    describe 'POST /phones/set_unavailable_selected' do
      let(:phones) { create_list(:phone, 5, store: store) }
      let(:ids) { phones.first(2).pluck(:id) }
      let(:params) { { ids: ids.join(',') } }
      subject { post set_unavailable_selected_phones_url, params: params }

      context 'logged in', :logged_in do
        it 'set unavailable all selected and ok respond (ajax response)' do
          expect { phones }.to change(Phone, :count).by(5)
          subject
          expect(response).to have_http_status(:ok)
          expect(Phone.unavailable.pluck(:id)).to eql(ids)
        end
      end
    end
  end

  context 'when user is manager' do # rubocop:todo Metrics/BlockLength
    let(:manager) { create(:staff, role: 'manager', store: store) }
    let(:user) { manager.user }

    include_context 'when user is any role'

    include_context 'when user is manager or admin'

    describe 'GET /phones/new' do
      subject { get new_phone_url }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /phones/new' do
      let(:params) { phone_params(quantity: 3) }

      subject { post phones_url, params: params }
      context 'logged in', :logged_in do
        it 'valid params, create correcly and redirect to index' do
          expect { subject }.to change(Phone, :count).by(3)
          expect(response).to redirect_to(phones_url)
          expect(Phone.first).to eql_phone_params(params)
          expect(Phone.first.store).to eql(store)
        end

        it 'invalid params, no create, redirect to new' do
          params[:phone][:memory] = -1
          expect { subject }.to change(Phone, :count).by(0)
          expect(response).to redirect_to(new_phone_url)
        end
      end

      include_examples 'not logged in'
    end
  end

  shared_examples 'when user is not manager', :logged_in do
    describe 'GET /phones/new' do
      subject { get new_phone_url }

      include_examples 'not authorized'
    end

    describe 'POST /phones/new' do
      let(:params) { phone_params(quantity: 3) }
      subject { post phones_url, params: params }

      include_examples 'not authorized'
    end
  end

  context 'when user is employee' do # rubocop:todo Metrics/BlockLength
    let(:employee) { create(:staff, store: store) }
    let(:user) { employee.user }

    include_context 'when user is any role'

    context 'when accessing unauthorized', :logged_in do # rubocop:todo Metrics/BlockLength
      include_examples 'when user is not manager'

      describe 'GET /phones/:id/edit' do
        let(:phone) { create(:phone, store: store) }
        subject { get edit_phone_url(phone) }
        include_examples 'not authorized'
      end

      describe 'PATCH /phones/:id' do
        let(:phone) { create(:phone, store: store) }
        let(:params) { phone_params(quantity: nil) }
        subject { patch phone_url(phone), params: params }
        include_examples 'not authorized'
      end

      describe 'DELETE /phones/:id' do
        let(:phones) { create_list(:phone, 5, store: store) }
        let(:delete_phone) { phones.last }
        subject { delete phone_url(delete_phone) }
        include_examples 'not authorized'
      end

      describe 'POST /phones/delete_selected' do
        let(:phones) { create_list(:phone, 5, store: store) }
        let(:ids) { phones.last(2).pluck(:id) }
        let(:params) { { ids: ids.join(',') } }
        subject { post delete_selected_phones_url, params: params }
        include_examples 'not authorized'
      end

      describe 'POST /phones/set_unavailable_selected' do
        let(:phones) { create_list(:phone, 5, store: store) }
        let(:ids) { phones.first(2).pluck(:id) }
        let(:params) { { ids: ids.join(',') } }
        subject { post set_unavailable_selected_phones_url, params: params }
        include_examples 'not authorized'
      end
    end
  end

  context 'when user is admin' do
    let(:user) { create(:user, role: 'admin', email: 'admin@admin.com') }

    include_context 'when user is any role'

    include_context 'when user is manager or admin'

    context 'when accessing unauthorized' do
      include_examples 'when user is not manager'
    end
  end
end
