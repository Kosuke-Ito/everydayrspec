require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates anew project" do
    user = FactoryBot.create(:user)
    # この章で独自に定義したログインヘルパーを使う場合
    # sign_in_as user
    # もしくは Devise が提供しているヘルパーを使う場合
    sign_in user
    visit root_path

    expect{ # capybara DSL
      click_link "New Project"
      fill_in "Name",	with: "Test Project" 
      fill_in "Description",	with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
end
