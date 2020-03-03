# frozen_string_literal: true

json.set! :books do
  json.partial! '/api/books/book', books: @books
end
