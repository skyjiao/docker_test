FROM a99docker001.cdweb.biz:5000/debian

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install build-essential -y
RUN apt-get install gfortran -y
RUN apt-get install libatlas-base-dev -y
RUN apt-get install apt-utils -y
RUN apt-get install python3-pip -y
RUN apt-get install python3-dev -y
RUN apt-get install python3 -y

RUN apt-get install -y mapr-keyring
COPY mapr.list /etc/apt/sources.list.d/mapr.list
RUN apt-get update
RUN apt-get install -y unixodbc unixodbc-dev maprhiveodbc mapr-client openjdk-7-jdk
COPY java_home.sh /etc/profile.d/java_home.sh
RUN /opt/mapr/server/configure.sh -N a01hmapravip.cdweb.biz -c -C a01hmapra001.cdweb.biz:7222,a01hmapra002.cdweb.biz:7222,a01hmapra003.cdweb.biz:7222
RUN sed -i -e 's/[#]*ODBCInstLib=libiodbcinst.so/#ODBCInstLib=libiodbcinst.so/g' -e 's/[#]*ODBCInstLib=libodbcinst.so/ODBCInstLib=libodbcinst.so/g' -e 's/[#]*DriverManagerEncoding=.*/DriverManagerEncoding=UTF-16/g' /opt/mapr/hiveodbc/lib/64/mapr.hiveodbc.ini
COPY odbcinst.ini /etc/
COPY odbc.ini /etc/

COPY similar_products.py /usr/local/bin/
COPY cdtools/ /usr/local/bin/cdtools/
COPY io_similar_products/ /usr/local/bin/io_similar_products/
COPY interpreter/ usr/local/bin/interpreter/

RUN chmod +x /usr/local/bin/similar_products.py
RUN chmod +wrx /usr/local/bin/cdtools/*.py

ENTRYPOINT ["/usr/local/bin/interpreter/bin/python", "/usr/local/bin/similar_products.py"]
