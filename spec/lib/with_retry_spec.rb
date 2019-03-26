# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  describe 'with_retry' do
    before do
      response = double('api_error_response')
      allow(response).to receive(:code).and_return('429')
      allow(response).to receive(:[]).with('Retry-After').and_return('0')
      @error = ActiveResource::ClientError.new(response)

      @failure_api_caller = double
      allow(@failure_api_caller).to receive(:call).and_raise(@error)

      @one_api_caller = double
      allow(@one_api_caller).to receive(:call).and_return('test')

      @three_api_caller = double
      call_count = 0
      allow(@three_api_caller).to receive(:call) do
        call_count += 1
        call_count > 2 ? 'test' : raise(@error)
      end
    end

    it 'should return result if api call succeeded at first time' do
      result = nil
      expect(@one_api_caller).to receive(:call).once
      with_retry do
        result = @one_api_caller.call
      end
      expect(result).to eq 'test'
    end

    it 'should retry if api call failed then return result' do
      result = nil
      expect(@three_api_caller).to receive(:call).exactly(3).times
      with_retry do
        result = @three_api_caller.call
      end
      expect(result).to eq 'test'
    end

    it 'should raise error if number of retries exceeded limit' do
      expect(@failure_api_caller).to receive(:call).exactly(10).times
      expect do
        with_retry do
          @failure_api_caller.call
        end
      end.to raise_error @error
    end
  end
end
