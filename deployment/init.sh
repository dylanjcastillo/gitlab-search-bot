set -e

APP_NAME=gitlab-search-bot
REPOSITORY_NAME=dylanjcastillo/gitlab-search-bot.git
PYTHON_VERSION=3.10

read -p "Do you want to download and install updates? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Updating system"
    sudo apt update && sudo apt upgrade -y
fi
echo

read -p "Do you want to download updates automatically? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Installing unattended-upgrades"
    sudo apt install unattended-upgrades apt-listchanges
    sudo dpkg-reconfigure -plow unattended-upgrades
fi
echo

read -p "Do you want to create a SSH key for deployment? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Creating SSH key"
    ssh-keygen -t ed25519 -C "dylanjcastillo@gmail.com"
    touch ~/.ssh/config 
    chmod 600 ~/.ssh/config 
    echo "Host github-$APP_NAME 
	HostName github.com 
    AddKeysToAgent yes 
    PreferredAuthentications publickey 
    IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
    echo "Copy the following key to your repository's deploy keys:"
    cat ~/.ssh/id_ed25519.pub
fi

read -p "Do you want to clone the repository? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Cloning repository"
    git clone git@github-$APP_NAME:$REPOSITORY_NAME
fi

read -p "Do you want to install python? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Installing python"
    sudo apt install software-properties-common -y && \
    sudo add-apt-repository ppa:deadsnakes/ppa && \
    sudo apt update && \
    sudo apt install python$PYTHON_VERSION python$PYTHON_VERSION-venv -y
fi
echo

read -p "Do you want to install supervisor and nginx? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Installing supervisor and nginx"
    sudo apt install supervisor nginx -y
    echo "Enabling supervisor"
    sudo systemctl enable supervisor && sudo systemctl start supervisor
fi
echo

read -p "Do you want to install your .vimrc? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Installing .vimrc"
    curl https://gist.githubusercontent.com/dylanjcastillo/7533db336820a66d11514c9c139e212e/raw/d1cce4a19f129be04db8d539e7d8f09e7d3fcbea/.vimrc > ~/.vimrc
    echo 'alias sudovim="sudo -E vim"' >> ~/.bashrc && source ~/.bashrc
fi

read -p "Do you want to install poetry? [y/n] (y)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
then
    echo "Installing poetry"
    curl -sSL https://install.python-poetry.org | python3 -
    poetry config virtualenvs.in-project true
fi
