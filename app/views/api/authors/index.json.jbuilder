# frozen_string_literal: true

json.set! :authors do
  json.array! @authors do |author|
    # json.extract! author, :id, :name, :birthday, :take_books
    json.extract! author, :id, :name
    json.books author.take_books(4), :id, :title, :impressions_count, :rakuten_book_info
  end
end
