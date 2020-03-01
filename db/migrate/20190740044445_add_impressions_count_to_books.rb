# frozen_string_literal: true

class AddImpressionsCountToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :impressions_count, :integer, default: 0
  end
end
