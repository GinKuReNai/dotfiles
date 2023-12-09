FROM ubuntu:latest

RUN apt-get update && apt-get install -y software-properties-common

RUN add-apt-repository ppa:neovim-ppa/stable -y && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  build-essential \
  curl \
  gcc \
  git \
  liblzma-dev \
  libxml2-dev \
  libxslt1-dev \
  locales \
  neovim \
  nodejs \
  npm \
  patch \
  python3 \
  python3-pip \
  ruby \
  ruby-dev \
  zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip pynvim

RUN gem install -N \
  etc \
  json \
  rubocop \
  rubocop-performance \
  rubocop-rails \
  rubocop-rspec \
  solargraph

RUN locale-gen en_US.UTF-8
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8"

ENV XDG_CONFIG_HOME="/root/.config"

# install packer
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  /usr/share/nvim/site/pack/packer/start/packer.nvim

COPY nvim /root/.config/nvim

# RUN nvim +:UpdateRemotePlugins +qa
RUN chmod -R 777 /root

ENTRYPOINT ["nvim"]
