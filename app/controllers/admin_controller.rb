# frozen_string_literal: true

# Admin Base Controller
class AdminController < ApplicationController
  before_action :authenticate_admin!
end
