# frozen_string_literal: true

class AddBooksCountToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :books_count, :integer, default: 0
  end
end
