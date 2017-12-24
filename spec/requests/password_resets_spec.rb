require 'spec_helper'

describe "PasswordResets" do
  xit "emails user when requesting password reset" do
    user = FactoryBot.create(:author)
    visit new_user_session_path
    click_link "Passwort vergessen?"
    fill_in "E-Mail", :with => user.email
    click_button "Anleitung schicken, um mein Passwort zurückzusetzen"
    expect(ActionMailer::Base.deliveries[0].to).to include(user.email)
  end

end
