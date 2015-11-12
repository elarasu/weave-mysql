# mysql 5.6 image
#   docker build -t elarasu/weave-mysql .
#
FROM elarasu/weave-ubuntu
MAINTAINER elarasu@outlook.com

# Add MySQL configuration
ADD conf/my.cnf /etc/mysql/conf.d/my.cnf
ADD conf/mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# mysql server
RUN  apt-get update \
  && apt-get install -yq mysql-server-5.6 pwgen --no-install-recommends \
  && if [ ! -f /usr/share/mysql/my-default.cnf ] ; then cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf; fi \
  && sed -e '/bind-address/ s/^#*/#/' -i /etc/mysql/mysql.conf.d/mysqld.cnf \
  && mysql_install_db > /dev/null 2>&1 \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /etc/mysql/conf.d/mysqld_safe_syslog.cnf \
  && touch /var/lib/mysql/.EMPTY_DB

# Add MySQL scripts
ADD import_sql.sh /import_sql.sh
ADD run.sh /run.sh

ENV MYSQL_USER=admin \
    MYSQL_PASS=**Random** \
    ON_CREATE_DB=**False** \
    REPLICATION_MASTER=**False** \
    REPLICATION_SLAVE=**False** \
    REPLICATION_USER=replica \
    REPLICATION_PASS=replica

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306
CMD ["/run.sh"]

