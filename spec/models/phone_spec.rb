# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do # rubocop:todo Metrics/BlockLength
  subject do
    model = create(:model)
    store = create(:store)
    color = create(:color)
    described_class.new(
      model: model, store: store, color: color,
      manufacture_year: 2015, condition: 'percent99', memory: 2345,
      price: BigDecimal('2554.33'), status: 'in_stock'
    )
  end

  it_behaves_like 'has valid attributes'

  context 'Must have valid store' do
    it_behaves_like 'must have field', 'store'
    it_behaves_like 'reference field', 'store'
  end

  context 'Must have valid color' do
    it_behaves_like 'must have field', 'color'
    it_behaves_like 'reference field', 'color'
  end

  context 'Must have valid model' do
    it_behaves_like 'must have field', 'model'
    it_behaves_like 'reference field', 'model'
  end

  context 'Must have valid manufacture_year' do
    it_behaves_like 'must have field', 'manufacture_year'
    it_behaves_like 'number field', 'manufacture_year'
    it_behaves_like 'non negative field', 'manufacture_year'
  end

  context 'Must have valid memory' do
    it_behaves_like 'must have field', 'memory'
    it_behaves_like 'number field', 'memory'
    it_behaves_like 'non negative field', 'memory'
  end

  context 'Must have valid price' do
    it_behaves_like 'must have field', 'price'
    it_behaves_like 'number field', 'price'
    it_behaves_like 'non negative field', 'price'
  end

  context 'Must have valid condition' do
    it_behaves_like 'must have field', 'condition'
    it_behaves_like 'inclusion field', 'condition', 'fake condition'
  end

  context 'Must have valid status' do
    it_behaves_like 'must have field', 'status'
    it_behaves_like 'inclusion field', 'status', 'fake status'
    it_behaves_like 'defaulted field', 'status', 'in_stock'
  end
end
