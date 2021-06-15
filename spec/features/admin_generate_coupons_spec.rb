require 'rails_helper'

feature 'Admin generetes coupons' do
  scenario 'with coupons quantity available' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    user2 = User.create!(email: 'joe_doe@locaweb.com.br', password: '123456')

    promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                  code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                  expiration_date: 1.day.from_now, user: user, user_approved: user2,
                                  status: :approved, approved_at: DateTime.current)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Emitir cupons'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('CARNA10-0001 (disponível)')
    expect(page).to have_content('CARNA10-0002 (disponível)')
    expect(page).to have_content('CARNA10-0003 (disponível)')
    expect(page).to have_content('CARNA10-0004 (disponível)')
    expect(page).to have_content('CARNA10-0005 (disponível)')
    expect(page).to have_content('Cupons gerados com sucesso')
    expect(page).to_not have_link('Emitir cupons')
  end

  scenario ' cupons are already generated' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    user2 = User.create!(email: 'joe_doe@locaweb.com.br', password: '123456')

    promotion = Promotion.create!(name: 'Carnaval', description: 'Promoção de Pascoa',
                                  code: 'CARNA10', discount_rate: 10, coupon_quantity: 5,
                                  expiration_date: 1.day.from_now, user: user, user_approved: user2,
                                  status: :approved, approved_at: DateTime.current)
    coupon = promotion.coupons.create!(code: 'ABCD')

    login_as user, scope: :user
    visit promotion_path(promotion)

    expect(page).to_not have_link('Emitir cupons')
    expect(page).to have_content(coupon.code)
  end
end
