require 'rails_helper'

feature 'Admin destroy a product category' do
  scenario 'successfully' do
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP')
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Categorias de produto'
    click_on 'Hospedagem'
    click_on 'Apagar'

    expect(current_path).to eq(product_categories_path)
    expect(page).to_not have_content('Hospedagem')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Categorias de produto')
  end
end
