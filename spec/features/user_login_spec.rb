require 'rails_helper'

feature 'User log in' do
  scenario 'and receive welcome message' do
    User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

    visit root_path
    click_on 'Log in'

    fill_in 'Email', with: 'jane_doe@locaweb.com.br'
    fill_in 'Password', with: '123456'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content('jane_doe@locaweb.com.br')
    expect(page).to_not have_content('Log in')
    expect(page).to have_content('Sair')
  end

  feature 'User log in' do
    scenario 'and receive welcome message' do
      User.create!(email: 'jane_doe@locaweb.com.br', password: '123456')

      visit root_path
      click_on 'Log in'

      fill_in 'Email', with: 'jane_doe@locaweb.com.br'
      fill_in 'Password', with: '123456'
      within 'form' do
        click_on 'Entrar'
      end

      click_on 'Sair'

      expect(current_path).to eq(root_path)
      expect(page).to_not have_content('jane_doe@locaweb.com.br')
      expect(page).to have_link('Log in')
      expect(page).to_not have_link('Sair')
    end
  end
end
