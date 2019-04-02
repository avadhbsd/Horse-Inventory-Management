# frozen_string_literal: true

# Session Controller Class
class SessionsController < Devise::SessionsController
  def new
    @page_title = 'Log In'
    super
  end
end
