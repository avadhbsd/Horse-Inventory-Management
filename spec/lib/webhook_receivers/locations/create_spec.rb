# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'location/create' do
    before do
      @store = Store.create
    end

    it 'should call sync on location' do
      location_params = { name: 'location' }

      receiver = WebhookReceivers::Locations::Create
                 .new(store: @store, params: location_params)

      expect(Location).to receive(:sync!).once
      receiver.receive!
    end
  end
end
