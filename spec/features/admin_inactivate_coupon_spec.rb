require 'rails_helper'

feature 'Admin inactivate coupon' do
  scenario 'successfully' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

    login_as user, scope: :user
    visit promotion_path(promotion)

    click_on 'Descartar cupom'

    expect(page).to have_content('Cupom cancelado com sucesso')
    expect(page).to have_content('CARNA10-0001 (cancelado)')
    expect(page).to_not have_link('Descartar cupom')
    expect(coupon.reload).to be_inactive
  end
end
