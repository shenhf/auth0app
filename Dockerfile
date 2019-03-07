FROM starefossen/ruby-node:latest

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ && \
    bundle config mirror.https://rubygems.org https://gems.ruby-china.com

RUN apt-get update -qq && \
  apt-get install -y apt-utils vim build-essential libpq-dev && \
  apt-get install -y zsh && \
  wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh && \
  sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="avit"' ~/.zshrc && \
  sed -i '/plugins=(git)/c\plugins=(git zsh-autosuggestions ruby bundler rails)' ~/.zshrc && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  echo "alias vi=vim" >> ~/.zshrc && \
  echo "syntax on" > ~/.vimrc && \
  echo "set background=dark" >> ~/.vimrc && \
  gem update --system && \
  gem install bundler

RUN mkdir /project
COPY Gemfile Gemfile.lock /project/
WORKDIR /project
RUN bundle install
COPY . /project
