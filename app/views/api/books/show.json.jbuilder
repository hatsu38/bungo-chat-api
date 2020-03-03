# frozen_string_literal: true

json.title @book.try(:title)
json.set! :words do
  json.array! @words.to_a.each_with_index.to_a do |word, index|
    json.id index
    json.text word
  end
end
