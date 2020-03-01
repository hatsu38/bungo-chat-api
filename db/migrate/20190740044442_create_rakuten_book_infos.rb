# frozen_string_literal: true

class CreateRakutenBookInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :rakuten_book_infos do |t|
      t.integer    :price
      t.string     :affiliate_url
      t.string     :small_image_url
      t.string     :medium_image_url
      t.text       :caption
      t.references :book, foreign_key: true

      t.timestamps null: false
    end
  end
end
