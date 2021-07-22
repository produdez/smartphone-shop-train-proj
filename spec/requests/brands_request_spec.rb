# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Brands', type: :request do # rubocop:todo Metrics/BlockLength
  let(:admin) { create(:user, role: 'admin', email: 'admin@admin.com') }

  before(:example, :logged_in) do
    sign_in admin
  end

  describe 'GET /brands' do
    subject { get brands_url }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /brands/new' do
    subject { get new_brand_url }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'POST /brands/' do
    let(:params) { { brand: attributes_for(:brand) } }
    subject { post brands_url, params: params }

    context 'Logged In', :logged_in do
      it 'should add new record and redirect' do
        expect { subject }.to change(Brand, :count).by(1)
        expect(response).to redirect_to(brands_url)
        expect(Brand.first).to eql_brand_params(params)
      end
    end

    it_behaves_like 'not logged in'
  end

  describe 'GET /brand/:id/edit' do
    let(:brand) { create(:brand) }
    subject { get edit_brand_url(brand) }

    context 'Logged In', :logged_in do
      it_behaves_like 'url_responds_ok'
    end

    it_behaves_like 'not logged in'
  end

  describe 'patch /brands/:id/' do
    let(:brand) { create(:brand) }
    let(:params) { { brand: attributes_for(:brand, name: 'Updated Brand') } }
    subject { patch brand_url(brand), params: params }

    context 'Logged In', :logged_in do
      it 'should return edit and redirect' do
        subject
        expect(response).to redirect_to(brands_url)
        created_brand = Brand.first
        expect(created_brand).to eql_brand_params(params)
        expect(created_brand.id).to eql(brand.id)
      end
    end

    it_behaves_like 'not logged in'
  end

  describe 'delete /brands/:id' do
    let(:brands) { create_list(:brand, 3) }
    let(:delete_brand) { brands.last }
    subject { delete brand_url(delete_brand) }

    context 'Logged In', :logged_in do
      it 'should return delete and redirect' do
        expect { brands }.to change(Brand, :count).by(3)
        expect { subject }.to change(Brand, :count).by(-1)
        expect(response).to redirect_to(brands_url)
        expect(Brand.where(id: delete_brand.id)).not_to exist
      end
    end

    it_behaves_like 'not logged in'
  end
end
