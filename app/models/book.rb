# frozen_string_literal: true

class Book < ApplicationRecord
  is_impressionable counter_cache: true

  validates :title, presence: true
  validates :txt_file, presence: true
  validates :bookid, presence: true, uniqueness: true

  belongs_to :author, counter_cache: :books_count
  has_one :rakuten_book_info
  has_one :ranking

  accepts_nested_attributes_for :rakuten_book_info

  scope :recent, ->(count) { order(id: :desc).limit(count) }
  scope :viewable, -> { where(is_published: true) }
  scope :efficiency_list, -> do
    includes(:author, :rakuten_book_info)
      .select('id', 'title', 'author_id', 'impressions_count')
      .order('rakuten_book_infos.medium_image_url desc')
  end

  def self.search(search)
    if search.present?
      where('title like ?', "%#{search}%").efficiency_list.limit(50)
    else
      joins(:ranking).includes(:author, :rakuten_book_info, :ranking).order('rank').limit(50)
    end
  end
end
