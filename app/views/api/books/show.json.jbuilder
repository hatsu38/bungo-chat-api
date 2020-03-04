# frozen_string_literal: true

json.title @book.try(:title)
json.image @book.try(:rakuten_book_info).try(:medium_image_url)
json.set! :sentences do
  json.array! @sentences.to_a.each_with_index.to_a do |sentence, index|
    json.id index
    json.text sentence.gsub(/\r\n|\r|\n|\s|\t|[[:space:]]/, "")
  end
end
