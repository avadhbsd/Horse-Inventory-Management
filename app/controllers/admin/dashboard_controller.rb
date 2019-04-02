# frozen_string_literal: true

# Admin Dashboard Controller
class Admin::DashboardController < AdminController
  def index
    @page_title = 'Main Dashboard'
  end
end
