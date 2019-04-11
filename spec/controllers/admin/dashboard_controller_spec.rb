# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DashboardController do
  describe 'Logged Out' do
    describe 'GET index' do
      it 'Redirects to the login path' do
        get :index
        expect(response).to redirect_to(admin_session_path)
      end
    end
  end

  describe 'Logged In' do
    before(:each) do
      sign_in_random_admin
    end

    describe 'GET index' do
      it 'Renders the index page' do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end
end
