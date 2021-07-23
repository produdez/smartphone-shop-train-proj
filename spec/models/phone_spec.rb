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

  include_examples 'has valid attributes'

  context 'Must have valid store' do
    include_examples 'must have field', 'store'
    include_examples 'reference field', 'store'
  end

  context 'Must have valid color' do
    include_examples 'must have field', 'color'
    include_examples 'reference field', 'color'
  end

  context 'Must have valid model' do
    include_examples 'must have field', 'model'
    include_examples 'reference field', 'model'
  end

  context 'Must have valid manufacture_year' do
    include_examples 'must have field', 'manufacture_year'
    include_examples 'number field', 'manufacture_year'
    include_examples 'non negative field', 'manufacture_year'
  end

  context 'Must have valid memory' do
    include_examples 'must have field', 'memory'
    include_examples 'number field', 'memory'
    include_examples 'non negative field', 'memory'
  end

  context 'Must have valid price' do
    include_examples 'must have field', 'price'
    include_examples 'number field', 'price'
    include_examples 'non negative field', 'price'
  end

  context 'Must have valid condition' do
    include_examples 'must have field', 'condition'
    include_examples 'inclusion field', 'condition', 'fake condition'
  end

  context 'Must have valid status' do
    include_examples 'must have field', 'status'
    include_examples 'inclusion field', 'status', 'fake status'
    include_examples 'defaulted field', 'status', 'in_stock'
  end
end
