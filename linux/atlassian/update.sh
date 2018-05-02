#!/bin/bash

echo "choose what do you want to upgrade: os, jira, confluence, bamboo, bitbucket"
while :
do
  read INPUT_STRING
  case $INPUT_STRING in

os)

echo "doing os update and upgrade"

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
exit
;;

confluence)

echo "doing confluence upgrade"

#settings
echo "enter target confluence version:"
read version

#download
rm -fr atlassian-confluence*
wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-$version-x64.bin

#stop service
echo "stopping confluence"
service confluence stop

#install
chmod +x atlassian-confluence-$version-x64.bin
sh atlassian-confluence-$version-x64.bin -q -varfile confluence/confluence-response.varfile
cp confluence/server.xml /opt/atlassian/confluence/conf/
chown -R confluence:root /opt/atlassian/confluence

#start service
echo "starting confluence"
service confluence start

#cleanup
rm -fr atlassian-confluence*
rm /opt/atlassian/*-modifications.txt
rm /opt/atlassian/*-back.zip
exit
;;

jira)

echo "doing jira upgrade"

#settings
echo "enter target jira version:"
read version

#download
rm -fr atlassian-jira*
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-$version-x64.bin

#stop service
echo "stopping jira"
service jira stop

#install
chmod +x atlassian-jira-software-$version-x64.bin
sh atlassian-jira-software-$version-x64.bin -q -varfile jira/jira-response.varfile
cp jira/server.xml /opt/atlassian/jira/conf/
chown -R jira:root /opt/atlassian/jira

#start service
echo "starting jira"
service jira start

#cleanup
rm -fr atlassian-jira*
rm -fr /opt/atlassian/*-modifications.txt
rm -fr /opt/atlassian/jira-*-back.zip
exit
;;
bamboo)

echo "doing bamboo upgrade"

#settings
echo "enter target bamboo version:"
read version

#download
rm -fr atlassian-bamboo*
wget https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$version.tar.gz

#stop service
echo "stopping bamboo"
service bamboo stop
pkill -G bamboo

#install
tar -zxf atlassian-bamboo-$version.tar.gz
rm -fr /opt/atlassian/bamboo/*
mv atlassian-bamboo-$version /opt/atlassian/bamboo/$version
ln -sfn /opt/atlassian/bamboo/$version /opt/atlassian/bamboo/current
cp bamboo/server.xml /opt/atlassian/bamboo/current/conf/
cp bamboo/mysql-connector-java-* /opt/atlassian/bamboo/current/atlassian-bamboo/WEB-INF/lib/
cp bamboo/bamboo-init.properties /opt/atlassian/bamboo/current/atlassian-bamboo/WEB-INF/classes/
chown -R bamboo:root /opt/atlassian/bamboo

#start service
echo "starting bamboo"
service bamboo start

#cleanup
rm -fr atlassian-bamboo*
exit
;;

bitbucket)

#settings
echo "enter target bitbucket version:"
read version

#download
rm -fr atlassian-bitbucket*
wget https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-$version-x64.bin

#stop service
echo "stopping bitbucket"
service atlbitbucket stop

#install
chmod +x atlassian-bitbucket-$version-x64.bin
rm -fr /opt/atlassian/bitbucket/*
sed -i "s|bitbucket/.*|bitbucket/$version|g" bitbucket/bitbucket-response.varfile
sh atlassian-bitbucket-$version-x64.bin -q -varfile bitbucket/bitbucket-response.varfile
chown -R atlbitbucket:root /opt/atlassian/bitbucket

#start service
echo "starting bitbucket"
service atlbitbucket start

#cleanup
rm -fr atlassian-bitbucket*

exit
;;

*)
echo "please select only appropriate action: os, jira, confluence, bamboo, bitbucket"
;;
esac
done
