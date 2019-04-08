# frozen_string_literal: true

# Admin dashboard helper
module AdminHelper
  def active_class(controller)
    current_controller = params[:controller].split('admin/')[1].to_sym
    'kt-menu__item--here' if current_controller == controller
  end
end
