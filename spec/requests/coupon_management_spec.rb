require 'rails_helper'

describe 'coupon management' do
  context 'show' do
    it 'render coupon JSON with discount' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                    code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                    expiration_date: '22/12/2033', user: user)

      coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

      get "/api/v1/coupons/#{coupon.code}"

      expect(response.status).to eq(200)
      expect(response.body).to include('10')
      expect(response.body).to include('22/12/2033')
    end

    it 'coupon not found' do
      get '/api/v1/coupons/ABCD123'

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('Cupom não encontrado')
    end
  end

  context 'burn coupon' do
    it 'change coupon status' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                    code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                    expiration_date: '22/12/2033', user: user)

      coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

      post "/api/v1/coupons/#{coupon.code}/burn", params: { order: { code: 'ORDER123' } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Cupom utilizado com sucesso')
      expect(coupon.reload).to be_burn
      expect(coupon.reload.order).to eq('ORDER123')
    end

    it 'coupon not found' do
    end

    it 'order must exists' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                    code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                    expiration_date: '22/12/2033', user: user)

      coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

      post "/api/v1/coupons/#{coupon.code}/burn", params: {}

      expect(response).to have_http_status(412)
    end

    it 'code must exists' do
      user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                    code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                    expiration_date: '22/12/2033', user: user)

      coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

      post "/api/v1/coupons/#{coupon.code}/burn", params: { order: {} }

      expect(response).to have_http_status(412)
    end
  end
end
