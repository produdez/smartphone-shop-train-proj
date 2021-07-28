# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Brands', type: :request do # rubocop:todo Metrics/BlockLength
  let(:user) { create(:user, role: 'admin', email: 'admin@admin.com') }

  describe 'GET /brands' do
    subject { get brands_url }

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

  describe 'GET /brands/new' do
    subject { get new_brand_url }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'POST /brands' do
    let(:params) { { brand: attributes_for(:brand) } }
    subject { post brands_url, params: params }

    context 'when user is admin' do
      context 'with valid params' do
        before { sign_in user }

        it 'add new record and redirect to index' do
          expect { subject }.to change(Brand, :count).by(1)
          expect(response).to redirect_to(brands_url)
          expect(Brand.first).to eql_brand_params(params)
        end
      end

      context 'with invalid params' do
        before { sign_in user }

        it 'do not create record, redirect to new' do
          params[:brand][:name] = ' '
          expect { subject }.to change(Brand, :count).by(0)
          expect(response).to redirect_to(new_brand_url)
        end
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'GET /brand/:id/edit' do
    let(:brand) { create(:brand) }
    subject { get edit_brand_url(brand) }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'PATCH /brands/:id' do # rubocop:todo Metrics/BlockLength
    let(:brand) { create(:brand) }
    let(:params) { { brand: attributes_for(:brand, name: 'Updated Brand') } }
    subject { patch brand_url(brand), params: params }

    context 'when user is admin' do
      context 'with valid params' do
        before { sign_in user }

        it 'update record and redirect to index' do
          subject
          expect(response).to redirect_to(brands_url)
          created_brand = Brand.first
          expect(created_brand).to eql_brand_params(params)
          expect(created_brand.id).to eql(brand.id)
        end
      end

      context 'with invalid params' do
        before { sign_in user }

        it 'do not change record, redirect to edit' do
          params[:brand][:name] = ' '
          subject
          expect(brand.name).to_not eql(params[:brand][:name])
          expect(response).to redirect_to(edit_brand_url(brand))
        end
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end

  describe 'DELTE /brands/:id' do
    let(:brands) { create_list(:brand, 3) }
    let(:delete_brand) { brands.last }
    subject { delete brand_url(delete_brand) }

    context 'when user is admin' do
      context 'when logged in' do
        before { sign_in user }

        it 'delete and redirect to index' do
          expect { brands }.to change(Brand, :count).by(3)
          expect { subject }.to change(Brand, :count).by(-1)
          expect(response).to redirect_to(brands_url)
          expect(Brand.where(id: delete_brand.id)).not_to exist
        end
      end

      include_examples 'not logged in'
    end

    include_examples 'when user is not admin'
  end
end
