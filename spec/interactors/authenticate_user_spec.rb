require 'rails_helper'

describe AuthenticateUser do

  describe "#call" do
    let(:interactor) { described_class.new(params: { email: 'user@example.org', password: 'password'}, request_ip: '0.0.0.0') }
    subject { interactor.call }
    context "invalid user" do
      it do
        expect(User).to receive(:find_by).with(email: 'user@example.org').and_return nil
        expect {
          subject
        }.to raise_error Interactor::Failure
      end
    end
    context "invalid password" do
      it do
        user = double('User')
        expect(user).to receive(:password_is?).with('password').and_return false
        expect(User).to receive(:find_by).with(email: 'user@example.org').and_return user
        expect {
          subject
        }.to raise_error Interactor::Failure
      end
    end
    context "valid user and password" do
      it do
        user = double('User')
        expect(user).to receive(:password_is?).with('password').and_return true
        expect(user).to receive(:update_columns).with(last_signed_in_ip: '0.0.0.0', last_signed_in_at: DateTime.now)
        expect(User).to receive(:find_by).with(email: 'user@example.org').and_return user
        subject
        expect(interactor.context.user).to eq user
      end
    end
  end

end
