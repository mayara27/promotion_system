require 'rails_helper'

feature 'Admin registers a promotion' do
  scenario 'from root path' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'

    expect(page).to have_link('Registrar uma promoção',
                              href: new_promotion_path)
  end

  scenario 'successfully' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP10')
    ProductCategory.create!(name: 'E-mail', code: 'EMAIL10')
    ProductCategory.create!(name: 'Clound', code: 'clound')

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check 'Hospedagem'
    check 'E-mail'
    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('Hospedagem')

    click_on 'Salvar'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
    expect(page).to have_content('jane_doe@locaweb.com.br') # teste user logado
    expect(page).to have_link('Voltar')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Promoções')
  end
end
