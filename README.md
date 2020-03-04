## 青空文庫の書籍を返すAPI

フロントエンド：https://github.com/hatsu38/bungo-chat-frontend/

サーバー：https://bungo-chat-api.herokuapp.com/

## API
- 本一覧：
https://bungo-chat-api.herokuapp.com/api/books
- 著者一覧：https://bungo-chat-api.herokuapp.com/api/authors
- 本のランキング：https://bungo-chat-api.herokuapp.com/api/ranking
- 本の詳細(文章を返す)：https://bungo-chat-api.herokuapp.com/api/books/%E6%88%96%E9%98%BF%E5%91%86%E3%81%AE%E4%B8%80%E7%94%9F?page=${page_num}&amount=${amount_num}
### デプロイ方法
```
# herokuにログイン
$ heroku login

# herokuのコンテナレジストリにログイン
heroku container:login

# イメージを作成してコンテナレジストリにpush
heroku container:push web

# DBセットアップ(必要に応じて)
heroku run rails db:migrate

# イメージをherokuへデプロイ
heroku container:release web
```

#### その他Herokuでよく使うコマンド
```
# 実際にアクセス
heroku open

# サーバーに入る
heroku run bash

# 再起動する
heroku restart

# RAILS_ENVをProduction環境に変更する
heroku config:add RAILS_ENV=production

# herokuに.envを送信する
# プラグイン追加
heroku plugins:install heroku-config
# .envを送信
heroku config:push
```


