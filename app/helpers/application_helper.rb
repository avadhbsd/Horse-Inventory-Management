# frozen_string_literal: true

# Horse application helper
module ApplicationHelper
  def page_title
    '| ' + @page_title if @page_title.present?
  end
end
