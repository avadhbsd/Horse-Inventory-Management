# frozen_string_literal: true

# Admin dashboard helper
module AdminHelper
  def active_item_class(controller, action)
    same_controller = (current_controller == controller)
    same_action = (current_action == action)
    'kt-menu__item--here' if same_controller && same_action
  end

  def open_menu_class(controller)
    'kt-menu__item--open' if current_controller == controller
  end

  private

  def current_controller
    params[:controller].split('admin/')[1].to_sym
  end

  def current_action
    params[:action].to_sym
  end
end
