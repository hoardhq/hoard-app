require 'rails_helper'

describe SessionsController do

  describe "#new" do
    context "no params" do
      it do
        expect(User).to receive(:new).with(email: nil).and_return 'new_user'
        get :new
        expect(controller.instance_variable_get('@user')).to eq 'new_user'
        expect(response.status).to eq 200
      end
    end
    context "preset params" do
      it do
        expect(User).to receive(:new).with(email: 'user@example.org').and_return 'new_user'
        get :new, user: { email: 'user@example.org' }
        expect(controller.instance_variable_get('@user')).to eq 'new_user'
        expect(response.status).to eq 200
      end
    end
  end

  describe "#create" do
    let(:user_params) { { 'email' => 'user@example.org', 'password' => 'password' } }
    subject { post :create, user: user_params }
    context "invalid user or password" do
      it do
        context = OpenStruct.new(:failure? => true, error: "Invalid username or password")
        expect(AuthenticateUser).to receive(:call).with(params: user_params, request_ip: '0.0.0.0').and_return context
        subject
        expect(session[:user_id]).to eq nil
        expect(flash[:error]).to eq "Invalid username or password"
        expect(response).to redirect_to new_session_path(user: { email: 'user@example.org' })
      end
    end
    context "valid user and password" do
      it do
        user = OpenStruct.new(id: 1)
        context = OpenStruct.new(:failure? => false, user: user)
        expect(AuthenticateUser).to receive(:call).with(params: user_params, request_ip: '0.0.0.0').and_return context
        subject
        expect(session[:user_id]).to eq user.id
        expect(flash[:success]).to eq "You are now signed in"
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    subject { delete :destroy }
    it do
      expect(controller.session).to receive(:delete).with(:user_id)
      subject
      expect(response).to redirect_to new_session_path
    end
  end

end
