require 'rails_helper'

feature 'Admin registers a product category' do
  scenario 'from root path' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_link('Registrar uma categoria',
                              href: new_product_category_path)
  end

  scenario 'successfully' do
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Categorias de produto'
    click_on 'Registrar uma categoria'

    fill_in 'Nome', with: 'Hospedagem'
    fill_in 'Codigo', with: 'HOSP'
    click_on 'Salvar'

    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('HOSP')
    expect(page).to have_link('Voltar')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Categorias de produto')
  end
end
