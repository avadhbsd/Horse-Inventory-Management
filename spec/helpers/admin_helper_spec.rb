# frozen_string_literal: true

require 'rails_helper'

class DummyClass
  include AdminHelper
  attr_accessor :params
end

RSpec.describe AdminHelper do
  describe 'GET index' do
    before(:each) do
      @dashboard_params = { controller: 'admin/dashboard', action: :index }
      @orders_params = { controller: 'admin/orders', action: :index }
      @test_instance = DummyClass.new
    end

    it 'Returns true if same as controller' do
      @test_instance.params = @dashboard_params
      expect(@test_instance.active_item_class(:dashboard, :index)).to be_truthy
    end

    it 'Returns false if a different controller' do
      @test_instance.params = @orders_params
      expect(@test_instance.active_item_class(:dashboard, :index)).to be_falsey
    end
  end
end
