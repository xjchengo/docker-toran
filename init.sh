#!/bin/bash

while true; do
    if [ -e '/var/www/toran/.init.lock' ]; then
        echo >&2 'Already initialized!'
        break
    fi

    apache2_status=`service apache2 status`
    if [ "$apache2_status" = 'apache2 is running.' ]; then
        sleep 5

        cp /var/www/toran/app/config/parameters.yml.dist /var/www/toran/app/config/parameters.yml

        sed -i "s/example.org/$TORAN_HOST/" /var/www/toran/app/config/parameters.yml
        sed -i "s/toran_http_port: 80/toran_http_port: $TORAN_HTTP_PORT/" /var/www/toran/app/config/parameters.yml
        sed -i "s/ThisTokenIsNotSoSecret-Change-It/$SECRET/" /var/www/toran/app/config/parameters.yml

        chown -R www-data:www-data /var/www/toran

        curl -v -L -c cookie http://127.0.0.1

        license_personal=1
        packagist_sync=1
        dist_sync_mode='new'
        git_path=''
        git_prefix=''
        satis_conf=''
        Install=''
        token=`curl -v -c cookie http://127.0.0.1/app.php/setup | grep -oP '_token\]".*value="\K[^"]*'`
        curl -v -b cookie -X POST \
                -F form[license_personal]=$license_personal \
                -F form[packagist_sync]=$packagist_sync \
                -F form[dist_sync_mode]=$dist_sync_mode \
                -F form[git_path]=$git_path \
                -F form[git_prefix]=$git_prefix \
                -F form[satis_conf]=$satis_conf \
                -F form[Install]=$Install \
                -F form[_token]=$token \
                http://127.0.0.1/app.php/setup
        rm cookie

        chsh -s /bin/bash www-data
        su -c "cd /var/www/toran && php bin/cron -v --no-interaction" www-data
        cat > /var/www/toran/app/toran/composer/auth.json <<- EOM
{
    "github-oauth": {
        "github.com": "$GITHUB_OAUTH_TOKEN"
    }
}
EOM

        crontab -u www-data /var/www/toran/crontab

        touch '/var/www/toran/.init.lock'
        break
    fi
    sleep 5
done
