# frozen_string_literal: true

AjaxDatatablesRails.configure do |config|
  config.db_adapter = :pg
end

module AjaxDatatablesRails
  # add filter_int function to AjaxDatatables
  class ActiveRecord < AjaxDatatablesRails::Base
    def filter_int(column_symbol)
      lambda do |column, query_string|
        query_type = query_string[0..1]
        raise 'Unkown Search Parameter' unless %w[
          eq lt gt
        ].include? query_type

        number = query_string[2..-1]
        column.table[column_symbol].send(query_type, number)
      end
    end
  end
end
