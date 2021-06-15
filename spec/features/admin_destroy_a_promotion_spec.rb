require 'rails_helper'

feature 'Admin destroy a promotion' do
  scenario 'successfully' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Apagar'

    expect(current_path).to eq(promotions_path)
    expect(page).to_not have_content('Natal')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Promoções')
  end
end
