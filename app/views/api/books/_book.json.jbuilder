# frozen_string_literal: true

json.array! books do |book|
  json.extract! book, :id, :title, :impressions_count, :author, :rakuten_book_info
end
