# frozen_string_literal: true

# Home Controller
class HomeController < ApplicationController
  def index
    redirect_to(admin_dashboard_path) && return
  end
end
