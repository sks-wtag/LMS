require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) {create(:user) }
  describe "confirmation" do
    let(:mail) { UserMailer.confirmation(user, user.generate_confirmation_token) }
    it "renders the headers" do
      expect(mail.subject).to eq("Confirmation instructions")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV['ADMINSTRATOR_EMAIL']])
    end
  end
  describe "Password_Reset" do
    let(:mail) { UserMailer.password_reset(user, user.generate_confirmation_token) }
    it "renders the headers" do
      expect(mail.subject).to eq("Password reset instruction")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV['ADMINSTRATOR_EMAIL']])
    end
  end

end
