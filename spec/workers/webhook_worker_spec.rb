# frozen_string_literal: true

require 'rails_helper'
RSpec.describe WebhookWorker, type: :worker do
  describe 'perform' do
    it 'should create instance of a receiver and call receive! on it' do
      receiver_klass = double
      receiver_instance = double
      allow(::WebhookReceivers::Base).to receive(:get_subclass_needed)
        .and_return(receiver_klass)
      allow(receiver_klass).to receive(:new).and_return(receiver_instance)
      allow(receiver_instance).to receive(:receive!)
      expect(receiver_instance).to receive(:receive!).once
      subject.perform(Store.create.id, {}, '')
    end
  end
end
