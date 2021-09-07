#!/bin/bash
/bin/yum update -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
/bin/yum install epel-release-latest-7.noarch.rpm -y
/bin/yum install git python python-devel python-pip openssl ansible -y