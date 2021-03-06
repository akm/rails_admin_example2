#
# 0. イメージ作り直し
# docker rm $(docker ps -a -q)
# docker rmi $(docker images -a | awk '/^<none>/{print $3}')
#
# 1. MySQLサーバ起動
# docker run --name mysql -e MYSQL_ROOT_PASSWORD=password -d mysql
#
# 2. イメージ作成時
# rm -rf public/assets && bundle exec rake assets:clean assets:precompile && docker build -t rails_admin_example2 .
#
# 3. DB初期化時
# docker run --link mysql:mysql  -v /var/log/app:/usr/src/app/log:rw rails_admin_example2 bundle exec rake db:drop db:create db:migrate db:seed
#
# 4. 環境変数
# export SECRET_KEY_BASE="67a1f3d844483f15e48f7607c6c7ef17785904470198d311bfdbd39d9f8b5997620a995a667d061539cafdeb48d1838a51f1d6ceb0e96e92b1e48b36f71afd97"
#
# 5. 実行
# docker run --link mysql:mysql -p 3000:3000 -v /var/log/app:/usr/src/app/log:rw -e SECRET_KEY_BASE=$SECRET_KEY_BASE -d -t groovenauts/rails_admin_example bundle exec rails server webrick
#
# 6. 確認
# 6-1. boot2dockerを使っている場合
#     1. boot2docker ip の出力からIPを確認
#     2. boot2docker info で"Docker Port"を確認
#     3. ブラウザで hhtp://#{1のIP}:#{2のポート} を開く
#

#
# 9. volumeの動作確認
#   1. コンテナ起動
#      docker run -v /var/log/app:/usr/src/app/log:rw --rm -it rails_admin_example2
#   2. ホスト側へログイン
#     a. boot2dockerを使っている場合 boot2docker ssh
#   3. コンテナ側でlogディレクトリを確認
#      ls -la /usr/src/app/log
#   4. ホスト側でlogディレクトリを確認
#      ls -la /var/log/app
#   5. コンテナ側でlogにファイルを作成
#      touch /usr/src/app/log/text.txt
#   4. ホスト側でlogディレクトリにファイルができていることを確認
#      ls -la /var/log/app
#   5. コンテナ側で作ったファイルを削除
#      rm /usr/src/app/log/text.txt
#

FROM groovenauts/ruby:2.1.2
MAINTAINER t-akima@groovenauts.jp

ENV RAILS_ENV production

EXPOSE 3000

ADD . /usr/src/app
WORKDIR /usr/src/app
VOLUME /usr/src/app/log

RUN bundle install --system

CMD ["bundle", "exec", "rails", "server"]

# CMD ["rails", "server", "thin"]
# ENTRYPOINT ["/usr/local/bin/bundle exec"]

