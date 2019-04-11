# frozen_string_literal: true

# Horse application helper
module ApplicationHelper
  def page_title
    '| ' + @title if @title.present?
  end
end
