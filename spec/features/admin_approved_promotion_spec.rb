require 'rails_helper'

feature 'Admin view promotions' do
  scenario 'successfully' do
    user = User.create!(email: 'joe_doe@locaweb.com.br', password: '123456')
    user2 = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user2, status: :not_approved)

    login_as user, scope: :user

    visit promotion_path(promotion)

    click_on('Aprovar Promoção')

    expect(page).to have_content('Promoção aprovada com sucesso')
    expect(page).to have_link('Emitir cupons')
  end
end
