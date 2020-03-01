# frozen_string_literal: true

namespace :ranking do
  desc '引数に設定した数までのランキングを収集する'
  task :add_ranking, [:ranking] => :environment do |_, args|
    require 'mechanize'
    RANKING_URL = 'https://www.aozora.gr.jp/access_ranking/2019_04_xhtml.html'

    agent = Mechanize.new
    page = agent.get(RANKING_URL)
    trs = page.search('table.list tbody tr')
    trs.each_with_index do |tr, i|
      break if i > args.ranking.to_i

      ranking_tag = tr.at('.normal')
      book_link_tag = tr.at('.normal a')
      next if ranking_tag.nil? || book_link_tag.nil?

      ranking = get_ranking(ranking_tag)
      card_num = get_card_num(book_link_tag)
      next if ranking.nil? || card_num.nil?

      book = Book.find_by(bookid: card_num)
      next if book.nil? || book.ranking

      book.create_ranking(rank: ranking)
    end
  end

  desc '500位までのランキングの本を登録(create)する'
  task :regist_book_ranking => :environment do
    require 'zip'
    require 'csv'
    require 'open-uri'

    WORK_TITLE = '作品名'
    WORK_TXT_ZIP_URL = 'テキストファイルURL'
    # base_dir = 'db/txt/'

    rank_books = get_top_rank_books(500)
    CSV.foreach('db/list_person_all_extended_utf8.csv', headers: true).with_index do |row, i|
      next unless rank_books.include?(row['作品ID'].to_i)

      puts i
      URI.parse(row[WORK_TXT_ZIP_URL]).open do |file|
        Zip::File.open_buffer(file.read) do |zip|
          zip.each do |entry|
            next unless entry.name.end_with?('.txt')

            save_path = entry.name.delete('.txt') + '/' + entry.name
            author = Author.find_by(authorid: row['人物ID'])
            if author.nil?
              author = Author.create!(name: row['姓'] + row['名'], birthday: row['生年月日'], authorid: row['人物ID'])
            end
            book = author.books.find_by(title: row[WORK_TITLE])
            if book.nil?
              published_str = row['底本初版発行年1'].gsub!(/（(.*?)）/, '')
              published = Date.strptime(published_str, '%Y年%m月%d日')
              book = author.books.create!(
                title: row[WORK_TITLE],
                published: published,
                txt_file: save_path,
                zip_url: row[WORK_TXT_ZIP_URL],
                bookid: row['作品ID'],
                is_published: true
              )
            end
            sleep 0.3
            next unless book.rakuten_book_info.nil?

            book_item = if RakutenWebService::Ichiba::Item.search(keyword: book.title + ' 文庫 ' + book.author.name).first.present?
                          RakutenWebService::Ichiba::Item.search(keyword: book.title + ' 文庫 ' + book.author.name).first
                        elsif RakutenWebService::Ichiba::Item.search(keyword: book.title + ' 小説 ' + book.author.name).first.present?
                          RakutenWebService::Ichiba::Item.search(keyword: book.title + ' 小説 ' + book.author.name).first
                        elsif RakutenWebService::Ichiba::Item.search(keyword: book.title + ' ' + book.author.name).first.present?
                          RakutenWebService::Ichiba::Item.search(keyword: book.title + ' ' + book.author.name).first
                        elsif RakutenWebService::Ichiba::Item.search(keyword: book.title).first.present?
                          RakutenWebService::Ichiba::Item.search(keyword: book.title).first
                        else
                          nil
                        end

            next unless book_item

            small_image_url = book_item['smallImageUrls'] ? book_item['smallImageUrls'][0] : nil
            medium_image_url = book_item['mediumImageUrls'] ? book_item['mediumImageUrls'][0] : nil

            book.create_rakuten_book_info(
              price: book_item['itemPrice'],
              affiliate_url: book_item['affiliateUrl'],
              small_image_url: small_image_url,
              medium_image_url: medium_image_url,
              caption: book_item['itemCaption']
            )
          end
        end
      end
    rescue StandardError => e
      Rails.logger.warn e
      next
    end

    system('bash bin/script/all_encode.sh')
    system('bundle exec rails txt_fix:all_txt_fix')
    system('bundle exec rails ranking:add_ranking[500]')
  end
end

def get_ranking(ranking_tag)
  return nil if ranking_tag.nil?

  ranking_tag.inner_text.to_i
end

def get_top_rank_books(rank)
  require 'mechanize'

  agent = Mechanize.new
  page = agent.get('https://www.aozora.gr.jp/access_ranking/2019_04_xhtml.html')
  trs = page.search('table.list tbody tr')
  top_rank_books = []
  trs.each_with_index do |tr, i|
    book_link_tag = tr.at('.normal a')
    next if book_link_tag.nil?

    card_num = get_card_num(book_link_tag)
    top_rank_books.push(card_num.to_i) if card_num
    return top_rank_books if i == rank
  end
end

def get_card_num(book_link_tag)
  book_link = book_link_tag.get_attribute(:href)
  card_num_html = book_link.match(/card\d+\.html/)
  return nil if card_num_html.nil?

  card_num = card_num_html[0].match(/\d+/)
  return nil if card_num.nil?

  card_num[0].to_i
end
