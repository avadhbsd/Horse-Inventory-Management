# frozen_string_literal: true

# Provide a retry mechanism. Will be used when querying Shopify API.
module Kernel
  def with_retry(retries = 10)
    begin
      result = yield
    rescue StandardError => e
      retries -= 1
      raise if retries.zero?

      sleep seconds_to_wait(e)
      retry
    end
    result
  end

  def seconds_to_wait(error)
    # Retry-After is returned when error code is 429.
    (error.response['Retry-After'] || 2).to_i
  end
end
