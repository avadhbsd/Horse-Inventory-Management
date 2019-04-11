# frozen_string_literal: true

# Admin Dashboard Controller
class Admin::DashboardController < AdminController
  def index
    @title = 'Main Dashboard'
  end
end
