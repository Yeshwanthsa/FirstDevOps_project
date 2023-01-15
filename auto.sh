!#/bin/bash
sudo apt update -y
#------Apache Installation Check-------
Required_PKG="apache2"
PKG_OK=$(dpkg-query -W --showformat='${status}\n' $Required_PKG | grep "install ok installed")
if [ "" = "$PKG_OK" ]
then
        echo "Apache is not available. Installing the Apache"
        sudo apt install apache2 -y
        echo "Apache Installed"
else
        echo "Apache is alreday installed"

fi
#----------------------------------------------------------------------------------------
#------AWCLI Installation Check-------
Required_PKG1="awscli"
PKG1_OK=$(dpkg-query -W --showformat='${status}\n' $Required_PKG1 | grep "install ok installed")
if [ "" = "$PKG1_OK" ]
then
        echo "awscli is not available. Installing the awscli"
        sudo apt install awscli -y
        echo "awscli Installed"
else
        echo "awscli is alreday installed"

fi
#---------------------------------------------------------------------------------------------
#------Apache2 Service Installation Check-------
if [ `service apache2 status | grep running | wc -l` == 1 ]
then
        echo "apache2 service running"
else
        sudo service apache2 start
        echo "service started now"

fi
#---------------------------------------------------------------------------------------------
#------Apache2 Service Enable Installation Check-------
#--To check for enabled apache2

if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
        echo "apache2 is enabled"
else
        sudo systemctl enable apache2
        echo "service enabled now"
fi
#---------------------------------------------------------------------------------------------
#------Apache2 Service Enable Installation Check-------
 cd /var/log/apache2/
        timestamp=$(date '+%d%m%Y-%H%M%S')
        tar -cvf /tmp/$name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
        aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar s3://$s3/$name-httpd-logs-$timestamp.tar
