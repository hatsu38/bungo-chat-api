# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.string  :name, null: false
      t.date    :birthday
      t.integer :authorid, null: false, unique: true

      t.timestamps null: false
    end
  end
end
