# frozen_string_literal: true

class Ranking < ApplicationRecord
  validates :rank, presence: true
  belongs_to :book
end
