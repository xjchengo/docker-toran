# Toran Image for Docker
Toran acts as a proxy for Packagist and GitHub. It is meant to be set up on your own server or even inside your office.
> [offical website](https://toranproxy.com/)

# How to use this image

## start a toran instance
	docker run -d -p 80:80 -e 'TORAN_HOST=http://your.hostname' index.alauda.cn/xjchengo/toran
This image includes `EXPOSE 80` (the http port), so you can access the proxy server by http://your.hostname.

## start with github oauth token
	docker run -d -p 80:80 -e 'TORAN_HOST=http://your.hostname' -e 'GITHUB_OAUTH_TOKEN=yourtoken' index.alauda.cn/xjchengo/toran
You need to setup a GitHub OAuth token because Toran makes a lot of requests and will use up the API calls limit if it is unauthenticated. Head to https://github.com/settings/tokens/new to create a token. You need to select the public_repo credentials, and the repo one if you are going to use private repositories from GitHub with Toran.

# Usage
see http://your.hostname for detailed info.
