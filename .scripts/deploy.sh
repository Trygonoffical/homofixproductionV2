#!/bin/bash
set -e

echo "Deployment started ..."

# Pull the latest version of the app
echo "Copying New changes...."
git pull origin main
echo "New changes copied to server !"

# Activate Virtual Env
#Syntax:- source virtual_env_name/bin/activate
source /home/armaan/actions-runner/_work/homofixproductionV2/env/bin/activate
echo "Virtual env 'env' Activated !"

echo "Clearing Cache..."
python manage.py clean_pyc
python manage.py clear_cache

echo "Installing Dependencies..."
pip install /home/armaan/actions-runner/_work/homofixproductionV2/homofixproductionV2 -r requirements.txt --no-input

echo "Serving Static Files..."
python /home/armaan/actions-runner/_work/homofixproductionV2/homofixproductionV2/manage.py collectstatic --noinput

echo "Running Database migration..."
python /home/armaan/actions-runner/_work/homofixproductionV2/homofixproductionV2/manage.py makemigrations
python /home/armaan/actions-runner/_work/homofixproductionV2/homofixproductionV2/manage.py migrate

# Deactivate Virtual Env
deactivate
echo "Virtual env 'mb' Deactivated !"

echo "Reloading App..."
#kill -HUP `ps -C gunicorn fch -o pid | head -n 1`
ps aux |grep gunicorn |grep homofix_Proj | awk '{ print $2 }' |xargs kill -HUP

echo "Deployment Finished !"