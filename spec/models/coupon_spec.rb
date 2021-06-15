require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      coupon = Coupon.new

      coupon.save

      expect(coupon.persisted?).to eq(false)
      expect(coupon.errors[:promotion]).to include('não pode ficar em branco')
      expect(coupon.errors[:code]).to include('não pode ficar em branco')
    end

    it 'code must be uniq' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033', user: user)

      Coupon.create!(promotion: promotion, code: 'NATAL10')
      coupon = Coupon.new(code: 'NATAL10')

      coupon.valid?

      expect(coupon.errors[:code]).to include('deve ser único')
    end
  end

  context '#title' do
    coupon = Coupon.new(code: 'NATAL10-0001', status: :active)
  end

  it 'status active' do
    coupon = Coupon.new(code: 'NATAL10-0001', status: :active)
    expect(coupon.title).to eq('NATAL10-0001 (disponível)')
  end

  it 'status inactive' do
    coupon = Coupon.new(code: 'NATAL10-0001', status: :inactive)
    expect(coupon.title).to eq('NATAL10-0001 (cancelado)')
  end
end
