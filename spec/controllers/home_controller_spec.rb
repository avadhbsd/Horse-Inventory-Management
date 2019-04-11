# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET index' do
    it 'Redirects to the admin index path' do
      get :index
      expect(response).to redirect_to(admin_dashboard_path)
    end
  end
end
