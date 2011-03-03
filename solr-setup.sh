#!/bin/bash

cd /tmp
echo "Installing tomcat..."
if [ ! -d /usr/local/tomcat6 ]; then
  if [ ! -e "apache-tomcat-6.0.29.tar.gz" ]; then
    wget "http://apache.cs.utah.edu//tomcat/tomcat-6/v6.0.29/bin/apache-tomcat-6.0.29.tar.gz";
  fi
  tar zxpvf apache-tomcat-6.0.29.tar.gz
  mv  apache-tomcat-6.0.29 /usr/local/tomcat6
fi
pushd /usr/local/tomcat6/bin
./startup.sh
popd
if [ $? -ne 0 ]; then
  echo "Failed to start tomcat";
  exit 1;
else
  echo "done"
  sleep 5
  pushd /usr/local/tomcat6/bin
  ./shutdown.sh
  popd
fi
if [ ! -e "apache-solr-1.4.1.tgz" ]; then
  echo "Downloading solr"
  wget "http://mirror.atlanticmetro.net/apache//lucene/solr/1.4.1/apache-solr-1.4.1.tgz";
fi
tar zxpvf apache-solr-1.4.1.tgz
pushd /usr/local/tomcat6
mkdir -p conf/Catalina conf/Catalina/localhost 
popd
SOLR_HOME=/usr/local/solr
mkdir -p $SOLR_HOME
cp -R apache-solr-1.4.1/example/solr/* $SOLR_HOME

cp apache-solr-1.4.1/dist/apache-solr-1.4.1.war $SOLR_HOME

sed -e "s!\(<dataDir>\${solr.data.dir:\)\.!\1${SOLR_HOME}!g" $SOLR_HOME/conf/solrconfig.xml > solrconfig.xml.temp
mv solrconfig.xml.temp $SOLR_HOME/conf/solrconfig.xml

pushd /usr/local/tomcat6/conf/Catalina/localhost

cat <<EOF > solrdev.xml
<?xml version="1.0" encoding="utf-8"?>
<Context docBase="$SOLR_HOME/apache-solr-1.4.1.war" debug="0" crossContext="true">
  <Environment name="solr/home" type="java.lang.String" value="$SOLR_HOME" override="true"/>
</Context>
EOF

#cat <<EOF > solrprod.conf
#<Context docBase="/usr/local/tomcat6/data/solr/apache-solr-1.4.1.war" debug="0" crossContext="true">
#  <Environment name="solr/home" type="java.lang.String" value="/usr/local/tomcat6/data/solr/prod" override="true"/>
#</Context>
#EOF

popd

pushd /usr/local/tomcat6/bin
sudo ./startup.sh
popd
