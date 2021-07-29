require 'rails_helper'

RSpec.describe "Projects", type: :system do
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
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

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    # プロジェクトを持ったユーザーを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    # ユーザーはログインしている
    login_as user, scope: :user
    # ユーザーがプロジェクト画面を開き、
    visit project_path(project)

    expect(page).to_not have_content "Completed"

    # "complete" ボタンをクリックすると、
    click_button "Complete"
    # プロジェクトは完了済みとしてマークされる
    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed" 
    expect(page).to_not have_button "Complete" 
  end


end
