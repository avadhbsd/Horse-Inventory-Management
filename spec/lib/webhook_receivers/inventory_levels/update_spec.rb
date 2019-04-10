# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'inventory_levels/update' do
    before do
      @store = Store.create
    end

    it 'should call sync on inventory_levels' do
      inventory_level_params = {
        inventory_item_id: 1,
        location_id: 1,
        available: 1
      }

      receiver = WebhookReceivers::InventoryLevels::Update
                 .new(store: @store, params: inventory_level_params)

      expect(InventoryLevel).to receive(:sync!).once
      receiver.receive!
    end
  end
end
