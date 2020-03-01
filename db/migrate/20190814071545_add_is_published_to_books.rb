# frozen_string_literal: true

class AddIsPublishedToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :is_published, :boolean, default: true
  end
end
