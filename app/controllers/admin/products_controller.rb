# frozen_string_literal: true

# Admin Products Dashboard Controller
class Admin::ProductsController < AdminController
  def index
    @page_title = 'Products'
  end
end
