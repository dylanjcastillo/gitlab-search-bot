#!/bin/bash
set -e

source utils.sh

if confirm_action "Do you want to create the logs and run directories?"
then
    echo "Creating logs directory"
    mkdir -p $PROJECT_DIR/logs;

    echo "Creating run directory"
    mkdir -p $PROJECT_DIR/run;
fi

if confirm_action "Do you want to create/update the gunicorn binary?"
then
    echo "Creating gunicorn binary"
    mkdir -p $PROJECT_DIR/bin;
    cp gunicorn_start $PROJECT_DIR/bin/gunicorn_start
    chmod u+x $PROJECT_DIR/bin/gunicorn_start
    sudo sed -i "s|APP_NAME|${APP_NAME}|g" $PROJECT_DIR/bin/gunicorn_start 
    sudo sed -i "s|PROJECT_DIR|${PROJECT_DIR}|g" $PROJECT_DIR/bin/gunicorn_start 
    sudo sed -i "s|PROJECT_SUBDIR|${PROJECT_SUBDIR}|g" $PROJECT_DIR/bin/gunicorn_start 
fi

if confirm_action "Do you want to create/update the supervisor config?"
then
    echo "Creating supervisor config"
    sudo cp $APP_NAME-supervisor.conf /etc/supervisor/conf.d/
    sudo sed -i "s|APP_NAME|${APP_NAME}|g" /etc/supervisor/conf.d/$APP_NAME-supervisor.conf 
fi

if confirm_action "Do you want to create/update the nginx config?"
then
    echo
    echo "Creating nginx config"
    sudo cp $APP_NAME-nginx.conf /etc/nginx/sites-available/$APP_NAME
    sudo sed -i "s|PROJECT_DIR|${PROJECT_DIR}|g" /etc/nginx/sites-available/$APP_NAME
fi

if confirm_action "Do you want to create/update the aliases?"
then
    echo "Removing old aliases"
    # Remove existing aliases
    sed -i '/alias gunicorn-logs/d' ~/.bashrc
    sed -i '/alias nginx-error-logs/d' ~/.bashrc
    sed -i '/alias nginx-access-logs/d' ~/.bashrc
    sed -i '/alias gunicorn-bin/d' ~/.bashrc
    sed -i '/alias nginx-conf/d' ~/.bashrc
    sed -i '/alias supervisor-conf/d' ~/.bashrc
    sed -i '/alias restart-supervisor/d' ~/.bashrc
    sed -i '/alias restart-app/d' ~/.bashrc
    sed -i '/alias restart-nginx/d' ~/.bashrc
    sed -i '/alias status-app/d' ~/.bashrc

    # Add new aliases
    echo "Creating new aliases"
    echo 'alias gunicorn-logs="tail -f '$PROJECT_DIR'/logs/gunicorn-error.log -n 10"' >> ~/.bashrc
    echo 'alias gunicorn-bin="vim '$PROJECT_DIR'/bin/gunicorn_start"' >> ~/.bashrc
    echo 'alias supervisor-conf="sudo -E vim /etc/supervisor/conf.d/'$APP_NAME'-supervisor.conf"' >> ~/.bashrc
    echo 'alias nginx-error-logs="tail -f '$PROJECT_DIR'/logs/nginx-error.log -n 10" ' >> ~/.bashrc
    echo 'alias nginx-access-logs="tail -f '$PROJECT_DIR'/logs/nginx-access.log -n 10"' >> ~/.bashrc
    echo 'alias nginx-conf="sudo -E vim /etc/nginx/sites-available/'$APP_NAME'"' >> ~/.bashrc
    echo "alias restart-supervisor='sudo supervisorctl reread && sudo supervisorctl update'" >> ~/.bashrc
    echo "alias restart-app='sudo supervisorctl restart "$APP_NAME"'" >> ~/.bashrc
    echo "alias restart-nginx='sudo systemctl restart nginx'" >> ~/.bashrc
    echo "alias status-app='sudo supervisorctl status "$APP_NAME"'" >> ~/.bashrc
fi 

# if users says yes, create a symlink to the nginx config
if confirm_action "Do you want to create a symlink to the nginx config in sites-enabled?"
then
    # don't create a symlink if it already exists
    if [ -L /etc/nginx/sites-enabled/$APP_NAME ]
    then
        echo "Symlink already exists"
        exit 0
    else
        echo "Creating symlink"
        sudo ln -s /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled  
    fi 
fi
