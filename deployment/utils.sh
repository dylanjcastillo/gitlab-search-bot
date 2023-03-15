APP_NAME=gitlab-search-bot
PROJECT_DIR=/home/ubuntu/gitlab-search-bot
PROJECT_SUBDIR=gitlab_search_bot
REPOSITORY_NAME=dylanjcastillo/gitlab-search-bot.git
PYTHON_VERSION=3.10

function confirm_action {
    read -p "$1 [y/n] (y)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
    then
        return 0
    else
        return 1
    fi
}
