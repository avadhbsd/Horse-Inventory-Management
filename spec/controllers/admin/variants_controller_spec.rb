# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::VariantsController do
  describe 'Logged Out' do
    describe 'GET show' do
      it 'Redirects to the login path' do
        get :show, params: { id: 1, product_id: 2 }
        expect(response).to redirect_to(admin_session_path)
      end
    end
  end

  describe 'Logged In' do
    before(:each) do
      sign_in_random_admin
      @s_p = SharedProduct.create!
      @s_p_v = SharedProductVariant.create!(shared_product_id: @s_p.id)
    end

    describe 'GET show' do
      it 'Renders the show page' do
        get :show, params: { id: @s_p_v.id, product_id: @s_p.id }
        expect(response.status).to eq(200)
      end
    end
  end
end
