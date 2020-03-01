# frozen_string_literal: true

class Author < ApplicationRecord
  validates :name, presence: true
  validates :authorid, presence: true, uniqueness: true
  has_many :books, dependent: :destroy

  scope :recent, ->(count) { order(id: :desc).limit(count) }

  def self.search(search)
    if search.present?
      where('name like ?', "%#{search}%").recent(30)
    else
      recent(30)
    end
  end

  def take_books(num)
    books.viewable.includes(:rakuten_book_info, :ranking)
      .select(:id, :title, :impressions_count)
      .order('rankings.rank is null, rankings.rank asc')
      .order(impressions_count: :desc)
      .order('rakuten_book_infos.medium_image_url desc').take(num)
  end
end
