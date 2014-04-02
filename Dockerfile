FROM ubuntu:saucy
MAINTAINER MATSUU Takuto <matsuu@gmail.com>

RUN apt-get update
#RUN apt-get upgrade
RUN apt-get install -y bison cmake g++ gcc git libaio-dev libncurses5-dev libreadline-dev make

# https://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html

RUN groupadd mysql && \
    useradd -r -g mysql mysql
RUN git clone https://github.com/webscalesql/webscalesql-5.6.git
RUN cd webscalesql-5.6 && \
    cmake . -DBUILD_CONFIG=mysql_release -DENABLE_DOWNLOADS=1 && \
    make && \
    make install && \
    cd .. && \
    rm -rf webscalesql-5.6
RUN cd /usr/local/mysql && \
    chown -R mysql . && \
    chgrp -R mysql . && \
    scripts/mysql_install_db --user=mysql && \
    chown -R root . && \
    chown -R mysql data && \
    echo "bind-address = 0.0.0.0" >> my.cnf && \
    cp support-files/mysql.server /etc/init.d/mysql.server

WORKDIR /usr/local/mysql
EXPOSE 3306
CMD ["bin/mysqld_safe", "--user=mysql"]
