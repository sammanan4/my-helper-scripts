#!/bin/bash

echo "Stopping airflow scheduler..."
sudo service airflow-scheduler stop
echo "Stopping airflow webserver..."
sudo service airflow-webserver stop

cd /home/sammanan4/office/tdms/CloudTDMS_V2/
git pull


echo "Updating code files..."
sudo find /opt/cloudtdms/dags/ -maxdepth 1  ! \( -name "bundle_dags" -o -name "app_dags" -o -name "dags" \) -exec rm -rf {} 2> /dev/null \;

sudo cp /home/sammanan4/office/tdms/CloudTDMS_V2/CloudTDMS/dags/* -r /opt/cloudtdms/dags/

echo "Updating libraries..."
sudo rm -rf /opt/cloudtdms/libraries/*

sudo cp /home/sammanan4/office/tdms/CloudTDMS_V2/CloudTDMS/libraries/* -r /opt/cloudtdms/libraries/


echo "Updating permissions"
sudo chown cloudtdms:cloudtdms -R /opt

echo "Starting airflow webserver and airflow scheduler..."
sudo service airflow-scheduler start
sudo service airflow-webserver start
