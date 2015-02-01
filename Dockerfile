#
# To create a fresh docker image run this command
# docker build -t docker.we7.local/blinkboxmusic/cucumber-grid .
# # Dont forget the dot at the end !
#
# To push the image to the we7 registry....
# docker push docker.we7.local/blinkboxmusic/cucumber-grid
#
# YOU DO NOT HAVE TO DO THE ABOVE UNLESS THE registry image needs updating
#
FROM debian:wheezy
MAINTAINER Trevor Stedman <trevor.stedman@gmail.com>

RUN apt-get update -qq && apt-get install -y locales -qq && locale-gen en_US.UTF-8 en_us && dpkg-reconfigure locales && dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8

RUN apt-get -qqy install ruby ruby-dev
RUN apt-get -qq install build-essential
RUN gem install bundler
ADD Gemfile Gemfile
RUN bundle install

EXPOSE 4567

ENTRYPOINT ["ruby", "/autopickle/autopickle-gui.rb", "-f", "/repo"]

ADD *.rb /autopickle/
ADD public /autopickle/public
