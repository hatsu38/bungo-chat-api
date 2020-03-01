# frozen_string_literal: true

require 'nkf'
namespace :txt_fix do
  desc '全txtファイルのルビを削除する'
  task all_txt_fix: :environment do
    Book.all.each do |book|
      txt_fix_format(Rails.root.join("db/txt/#{book.txt_file}"))
    rescue StandardError
      next
    end
  end

  desc '指定されたtxtファイルのルビを削除する'
  task :txt_fix, ['filename'] => :environment do |_task, args|
    txt_fix_format(Rails.root.join(args.filename))
  end
end

def txt_fix_format(path)
  buffer = File.open(path, 'r', &:read)
  # バックアップ用ファイルを開いて、バッパを書き込む（バックアップ作成）
  File.open("#{path}.bak", 'w') { |f| f.write(buffer) }
  # bufferの中身を変換
  text = buffer.gsub(/--{20,}.[\s\S]+?--{20,}/, '').gsub(/｜/, '').gsub(/《.+?》/, '').gsub(/［.+?］/, '').gsub(/\n(\s|　)*\n/, "\n")
  # bufferを元のファイルに書き込む
  File.open(path, 'w') { |f| f.write(text) }
end
