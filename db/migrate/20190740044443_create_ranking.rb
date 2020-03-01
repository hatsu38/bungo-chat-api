# frozen_string_literal: true

class CreateRanking < ActiveRecord::Migration[5.2]
  def change
    create_table :rankings do |t|
      t.integer :rank, null: false
      t.references :book, foreign_key: true

      t.timestamps null: false
    end
  end
end
