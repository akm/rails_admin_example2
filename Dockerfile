FROM ruby
MAINTAINER t-akima@groovenauts.jp
# RUN gem install rubygems-update --no-ri --no-rdoc
# RUN update_rubygems
# RUN gem install bundler --no-ri --nordoc
RUN mkdir -p /srv/rails_admin_example2
ADD . /srv/rails_admin_example2
WORKDIR /srv/rails_admin_example2

EXPOSE 3000
ENV RAILS_ENV production
VOLUME /srv/rails_admin_example2/log

RUN bundle install
RUN bundle exec rake db:drop db:seed
CMD bundle exec rails server thin
