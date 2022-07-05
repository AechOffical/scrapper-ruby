FROM ubuntu:latest

RUN apt-get update && apt-get install
RUN apt install sudo
RUN apt install -y curl gnupg software-properties-common
RUN apt-add-repository -y ppa:rael-gc/rvm
RUN apt-get update
RUN /bin/bash -l -c "sudo apt-get -y install rvm"
RUN useradd -m -G sudo hosting
RUN /bin/bash -l -c "usermod -a -G rvm  hosting"
RUN sudo apt-get install zlib1g-dev libssl-dev

RUN sudo apt-get install openssl

USER hosting
WORKDIR /home/hosting
SHELL [ "/bin/bash", "-l", "-c" ]
RUN mkdir -p /home/hosting/workspace
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN echo 'source "/etc/profile.d/rvm.sh"' >> ~/.bashrc
RUN rvm autolibs disable
RUN rvm install ruby-3.1.2

RUN rvm use 3.1.2 --default 
RUN gem source https://rubygems.org/
RUN gem install bundler




