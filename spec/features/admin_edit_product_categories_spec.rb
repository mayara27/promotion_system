require 'rails_helper'

feature 'Admin edit product categories' do
  scenario 'from root path' do
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP')
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Categorias de produto'
    click_on 'Hospedagem'

    expect(page).to have_link('Editar', href: edit_product_category_path(ProductCategory.last))

    click_on 'Editar'

    expect(current_path).to eq(edit_product_category_path(ProductCategory.last))
    expect(page).to have_field('Nome', with: 'Hospedagem')
    expect(page).to have_field('Codigo', with: 'HOSP')

    fill_in 'Nome', with: 'Email'
    fill_in 'Codigo', with: 'EMAIL'
    click_on 'Salvar'

    expect(current_path).to eq(product_category_path(ProductCategory.last))
    expect(page).to have_content('Email')
    expect(page).to have_content('EMAIL')
    expect(page).to have_link('Voltar')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Categorias de produto')
  end
end
