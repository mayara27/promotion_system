require 'rails_helper'

feature 'Admin view product categories' do
  scenario 'successfully' do
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP')
    ProductCategory.create!(name: 'E-mail', code: 'EMAIL')
    user = User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('E-mail')
  end

  scenario 'admin not logged in' do
    visit root_path
    expect(page).to_not have_link('Categorias de produto')
  end
end
