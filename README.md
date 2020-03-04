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


