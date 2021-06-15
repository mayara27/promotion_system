require 'rails_helper'

describe Promotion do
  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      promotion.save

      expect(promotion.persisted?).to eq(false)
      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em '\
                                                          'branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em'\
                                                            ' branco')
    end

    # TO DO: NAO PODE EMITIR CUPOM
    # COM A DATA EXPIRADA

    it 'code must be uniq' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033', user: user)
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('deve ser único')
    end
  end

  context '#generate_coupons!' do
    it 'of a proomotion without coupons' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                    code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                    expiration_date: 1.day.from_now, user: user)
      promotion.generate_coupons!

      expect(promotion.coupons.count).to eq(5)
      expect(promotion.coupons.map(&:code)).to contain_exactly(
        'CARNA10-0001', 'CARNA10-0002', 'CARNA10-0003',
        'CARNA10-0004', 'CARNA10-0005'
      )
    end

    it 'and coupons already genereted' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                    code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                    expiration_date: 1.day.from_now, user: user)

      promotion.generate_coupons!

      expect { promotion.generate_coupons! }.to raise_error('Cupons já foram gerados')

      expect(promotion.coupons.count).to eq(5)
      expect(promotion.coupons.map(&:code)).to contain_exactly(
        'CARNA10-0001', 'CARNA10-0002', 'CARNA10-0003',
        'CARNA10-0004', 'CARNA10-0005'
      )
    end
  end
end
