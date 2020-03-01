# frozen_string_literal: true

class Api::AuthorsController < ApplicationController
  PER = 10
  def index
    @authors = Author.joins(:books).includes(:books).page(params[:page]).per(PER).order(books_count: :desc)
  end

  def show
    @author = Author.find_by(name: params[:name])
    @books =  if @author
                @author.books
                  .includes(:author, :rakuten_book_info, :ranking)
                  .order(Arel.sql('rankings.rank is null, rankings.rank asc'))
                  .order('rakuten_book_infos.medium_image_url desc')
                  .page(params[:page]).per(PER)
              else
                nil
              end
  end
end
