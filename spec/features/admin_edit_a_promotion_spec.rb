require 'rails_helper'

feature 'Admin edit product categories' do
  scenario 'from root path' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(page).to have_link('Editar', href: edit_promotion_path(Promotion.last))

    click_on 'Editar'

    expect(current_path).to eq(edit_promotion_path(Promotion.last))

    expect(page).to have_field('Nome', with: 'Natal')
    expect(page).to have_field('Descrição', with: 'Promoção de Natal')
    expect(page).to have_field('Código', with: 'NATAL10')
    expect(page).to have_field('Desconto', with: '10.0')
    expect(page).to have_field('Quantidade de cupons', with: '100')
    expect(page).to have_field('Data de término', with: '2033-12-22')

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'

    click_on 'Salvar'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('90')
    expect(page).to have_content('22/12/2033')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Promoções')
  end
end
