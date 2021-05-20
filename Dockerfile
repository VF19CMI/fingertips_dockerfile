FROM ubuntu:16.04
MAINTAINER Georgi Martsenkov <georgi.martsenkov@vodafone.com>

SHELL ["/bin/bash", "-c"]

RUN apt-get update -yqq && apt-get install -yqq locales
RUN locale-gen en_US.UTF-8

ENV HOME /root
ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
ENV SHELL /bin/bash
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV CONFIGURE_OPTS --disable-install-doc

RUN apt-get update -yqq && apt-get install -yqq wget lsb-release software-properties-common locales
RUN locale-gen en_US.UTF-8
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN RELEASE=$(lsb_release -cs) && echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}"-pgdg main | tee  /etc/apt/sources.list.d/pgdg.list
RUN apt-get update -yqq && apt-get install -yqq \
      build-essential \
      checkinstall \
      libssl-dev \
      bash \
      npm \
      sudo \
      libpng-dev \
      alien \
      libaio1 \
      libaio-dev \
      libxml2-dev \
      libxslt1-dev \
      libxml2-dev \
      libxslt1-dev \
      git \
      curl \
      libpq-dev \
      postgresql-11 \
      postgresql-contrib \
      postgresql-server-dev-11 \
      postgresql-server-dev-13 \
      apt-transport-https\
      nodejs \
      sqlite3 \
      vim \
      tmux \
      wget \
      libmysqlclient-dev \
      autoconf \
      unzip \
      libsqlite3-dev ;

RUN apt-get -yqq update \
  && DEBIAN_FRONTEND=noninteractive apt-get -q -y install wget \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Oracle stuff
RUN mkdir -p /opt/oracle
RUN mkdir -p /opt/oracle_fdw
COPY ./vendor/*.rpm /opt/oracle/
COPY ./vendor/oracle_fdw/* /opt/oracle_fdw/

ENV ORACLE_HOME /usr/lib/oracle/12.1/client64
ENV LD_LIBRARY_PATH $ORACLE_HOME/lib/:$LD_LIBRARY_PATH
ENV NLS_LANG American_America.UTF8
ENV PATH $ORACLE_HOME/bin:$PATH

# Install Oracle Client
RUN alien -i /opt/oracle/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm \
  && alien -i /opt/oracle/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm \
  && alien -i /opt/oracle/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm

RUN cd /opt/oracle_fdw && make && make install

RUN echo "LD_LIBRARY_PATH='/usr/lib/oracle/12.1/client64/lib'" >> /etc/postgresql/11/main/environment
RUN echo "NLS_LANG=American_America.UTF8" >> /etc/postgresql/11/main/environment

ENV PGDATA /dev/shm/pgdata/data
RUN postgresfile=/usr/share/postgresql/11/postgresql.conf.sample; \
    echo fsync=off >> $postgresfile &&\
    echo synchronous_commit=off >> $postgresfile &&\
    echo full_page_writes=off >> $postgresfile &&\
    echo bgwriter_lru_maxpages=0 >> $postgresfile

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
ENV PATH $HOME/.asdf/bin::$PATH
ENV PATH $HOME/.asdf/shims::$PATH
RUN echo '. $HOME/.asdf/asdf.sh' > ~/.bashrc
RUN asdf plugin add erlang
RUN asdf plugin add elixir
RUN asdf install erlang 23.1.1
RUN asdf install elixir 1.11.2
RUN asdf global elixir 1.11.2
RUN asdf global erlang 23.1.1
