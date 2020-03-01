# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string  :title, null: false
      t.string  :txt_file, null: false
      t.date    :published
      t.string  :zip_url, null: false
      t.integer :bookid, null: false, unique: true
      t.references :author, foreign_key: true

      t.timestamps null: false
    end
  end
end
