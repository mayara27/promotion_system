require 'rails_helper'

feature 'Admin search a coupon' do
  scenario 'successfully' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

    login_as user, scope: :user

    visit promotions_path
    fill_in 'Buscar cupom', with: 'CARNA10-0001'
    click_on 'Buscar'

    expect(page).to have_content('CARNA10-0001')
  end

  scenario 'search blank' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

    login_as user, scope: :user

    visit promotions_path

    click_on 'Buscar'

    expect(page).to have_content('Pesquisa em branco')
  end

  scenario 'coupon not exists' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(promotion: promotion, code: 'CARNA10-0001')

    login_as user, scope: :user

    visit promotions_path
    fill_in 'Buscar cupom', with: 'Cupom'
    click_on 'Buscar'

    expect(page).to have_content('Nenhum cupom encontrado.')
  end
end
