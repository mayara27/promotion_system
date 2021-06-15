require 'rails_helper'

describe ProductCategory do
  context 'validation' do
    it 'attributes cannot be blank' do
      product_category = ProductCategory.new

      product_category.save

      expect(product_category.persisted?).to eq(false)
      expect(product_category.errors[:name]).to include('não pode ficar em branco')
      expect(product_category.errors[:code]).to include('não pode ficar em branco')
    end

    it 'code must be uniq' do
      ProductCategory.create!(name: 'Natal', code: 'NATAL10')
      product_category = ProductCategory.new(code: 'NATAL10')

      product_category.valid?

      expect(product_category.errors[:code]).to include('deve ser único')
    end
  end
end
