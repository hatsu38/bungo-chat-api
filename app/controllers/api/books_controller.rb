# frozen_string_literal: true

class Api::BooksController < ApplicationController
  require 'zip'
  require 'csv'
  require 'open-uri'

  PER = 20
  def index
    @books = Book.viewable.efficiency_list.page(params[:page]).per(PER)
  end

  def show
    @book = Book.find_by(title: params[:title])
    return @words = nil if @book.nil?

    page = params[:page].to_i
    txt_path = "db/txt/#{@book.txt_file}"
    download_txt(@book.zip_url, txt_path) unless File.exist?(txt_path)
    File.open(txt_path, 'r') do |f|
      @words = f.read.split(/(?<=。)/)[page..(page+5)]
    end
  rescue StandardError => e
    logger.warn(e.inspect)
  end

  def search
    @books = Book.viewable.search(params[:title])
  end

  def ranking
    @books = Book.viewable.joins(:ranking).includes(:author, :rakuten_book_info, :ranking).order('rank').page(params[:page]).per(PER)
  end

  def download_txt(zip_url, txt_path)
    base_dir = 'db/txt/'
    URI.parse(zip_url).open do |file|
      Zip::File.open_buffer(file.read) do |zip|
        zip.each do |entry|
          next unless entry.name.end_with?('.txt')

          save_path = entry.name.delete('.txt') + '/' + entry.name
          Dir.mkdir(base_dir + entry.name.delete('.txt'))
          zip.extract(entry, base_dir + save_path) { true }
        end
      end
    end
    %x("bash `nkf -w -Lu --overwrite #{txt_path}`")
    txt_fix_format(txt_path)
  end

  private

  def txt_fix_format(path)
    buffer = File.open(path, 'r', &:read)
    # バックアップ用ファイルを開いて、バッパを書き込む（バックアップ作成）
    File.open("#{path}.bak", 'w') { |f| f.write(buffer) }
    # bufferの中身を変換
    text = buffer.gsub(/--{20,}.[\s\S]+?--{20,}/, '').gsub(/｜/, '').gsub(/《.+?》/, '').gsub(/［.+?］/, '').gsub(/\n(\s|　)*\n/, "\n")
    # bufferを元のファイルに書き込む
    File.open(path, 'w') { |f| f.write(text) }
  end
end
