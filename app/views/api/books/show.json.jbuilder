# frozen_string_literal: true

json.title @book.try(:title)
json.set! :sentences do
  json.array! @sentences.to_a.each_with_index.to_a do |sentence, index|
    json.id index
    json.text sentence
  end
end
