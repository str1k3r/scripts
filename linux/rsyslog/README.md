# General Steps
### Upgrade rsyslog to 8.x (for wildcard logs shipping support)
```
sudo add-apt-repository ppa:adiscon/v8-stable
sudo apt-get update
sudo apt-get install rsyslog
```

# Client Side (Sender)

### Create /etc/rsyslog.d/5-datahandler.conf with the following content:
```
module(load="imfile" mode="inotify")
template (name="LongTagForwardFormat" type="string"

string="<%PRI%>%TIMESTAMP:::date-rfc3339% %HOSTNAME% %syslogtag%%$.suffix%%msg:::sp-if-no-1st-sp%%msg%")
 
ruleset(name="sendToLogserver") {
        action(type="omfwd" target="datahandler-rsyslog" protocol="tcp" port="514"
        action.resumeRetryCount="100" queue.type="linkedList" queue.size="10000" Template="LongTagForwardFormat")
        }
 
input(type="imfile" tag="" file="/srv/datahandler/runtime/log/app/*.log" ruleset="logs" addMetadata="on")
 
ruleset(name="logs"){
        set $.suffix=re_extract($!metadata!filename, "(.*)/([^/]*)", 0, 2, "all.log");
        call sendToLogserver
        }
```
### Add the following line to the /etc/hosts

```
%RECEIVER_IP% datahandler-rsyslog
```
### Restart rsyslog service

```
sudo service rsyslog restart
```

### Repeat the same on all servers
# Server Side (Receiver)
### Enable TCP reception in the /etc/rsyslog.conf
```
# provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
$AllowedSender TCP, 172.31.0.0/16
```
### Create the directory for the logs
```
mkdir /var/log/datahandler
chown syslog:adm /var/log/datahandler -R
```
### Create /etc/rsyslog.d/5-datahandler.conf with the following content:
```
input(type="imtcp" port="514" ruleset="datahandler_rule")
template(name="datahandler" type="string" string="/var/log/datahandler/%HOSTNAME%/%programname%.log")
ruleset(name="datahandler_rule"){
action(type="omfile" DynaFile="datahandler") stop
}
```
### Restart rsyslog service
```
sudo service rsyslog restart
```
