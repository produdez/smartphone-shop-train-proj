# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Brands', type: :request do # rubocop:todo Metrics/BlockLength
  before(:example, :logged_in) do
    sign_in user
  end

  RSpec.shared_context 'when user is any role' do
    describe 'GET /brands' do
      subject { get brands_url }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end
  end

  RSpec.shared_examples 'when user is not admin', :logged_in do
    describe 'GET /brands/new' do
      subject { get new_brand_url }
      include_examples 'not authorized'
    end

    describe 'POST /brands/' do
      let(:params) { { brand: attributes_for(:brand) } }
      subject { post brands_url, params: params }
      include_examples 'not authorized'
    end

    describe 'GET /brands/:id/edit' do
      let(:brand) { create(:brand) }
      subject { get edit_brand_url(brand) }
      include_examples 'not authorized'
    end

    describe 'PATCH /brands/:id/' do
      let(:brand) { create(:brand) }
      subject { patch brand_url(brand), params: {} }
      include_examples 'not authorized'
    end

    describe 'DELETE /brands/:id/' do
      let(:brands) { create_list(:brand, 3) }
      let(:delete_brand) { brands.last }
      subject { delete brand_url(delete_brand) }
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

    describe 'GET /brands/new' do
      subject { get new_brand_url }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'POST /brands/' do
      let(:params) { { brand: attributes_for(:brand) } }
      subject { post brands_url, params: params }

      context 'logged in', :logged_in do
        it 'valid params, add new record and redirect to index' do
          expect { subject }.to change(Brand, :count).by(1)
          expect(response).to redirect_to(brands_url)
          expect(Brand.first).to eql_brand_params(params)
        end

        it 'invalid params, no create, redirect to new' do
          params[:brand][:name] = ' '
          expect { subject }.to change(Brand, :count).by(0)
          expect(response).to redirect_to(new_brand_url)
        end
      end

      include_examples 'not logged in'
    end

    describe 'GET /brand/:id/edit' do
      let(:brand) { create(:brand) }
      subject { get edit_brand_url(brand) }

      context 'logged in', :logged_in do
        include_examples 'url responds ok'
      end

      include_examples 'not logged in'
    end

    describe 'patch /brands/:id/' do
      let(:brand) { create(:brand) }
      let(:params) { { brand: attributes_for(:brand, name: 'Updated Brand') } }
      subject { patch brand_url(brand), params: params }

      context 'logged in', :logged_in do
        it 'valid params, edit and redirect to index' do
          subject
          expect(response).to redirect_to(brands_url)
          created_brand = Brand.first
          expect(created_brand).to eql_brand_params(params)
          expect(created_brand.id).to eql(brand.id)
        end

        it 'invalid params, no change, redirect to edit' do
          params[:brand][:name] = ' '
          subject
          expect(brand.name).to_not eql(params[:brand][:name])
          expect(response).to redirect_to(edit_brand_url(brand))
        end
      end

      include_examples 'not logged in'
    end

    describe 'delete /brands/:id' do
      let(:brands) { create_list(:brand, 3) }
      let(:delete_brand) { brands.last }
      subject { delete brand_url(delete_brand) }

      context 'logged in', :logged_in do
        it 'delete and redirect to index' do
          expect { brands }.to change(Brand, :count).by(3)
          expect { subject }.to change(Brand, :count).by(-1)
          expect(response).to redirect_to(brands_url)
          expect(Brand.where(id: delete_brand.id)).not_to exist
        end
      end

      include_examples 'not logged in'
    end
  end
end
