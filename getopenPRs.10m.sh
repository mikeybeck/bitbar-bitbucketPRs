#!/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck source=/dev/null

# <bitbar.title>BB PRs</bitbar.title>
# <bitbar.version>0.1</bitbar.version>
# <bitbar.author>Mikey Beck</bitbar.author>
# <bitbar.author.github>mikeybeck</bitbar.author.github>
# <bitbar.desc>Shows bitbucket PR stuff</bitbar.desc>
# <bitbar.image></bitbar.image>
# <bitbar.dependencies>jq</bitbar.dependencies>
# <bitbar.abouturl></bitbar.abouturl>

# Relevant documentation for BitBucket: http://web.archive.org/web/20150530151816/https://confluence.atlassian.com/display/BITBUCKET/pullrequests+Resource#pullrequests

USERNAME=
PASSWORD=

REPO_OWNER=
REPO_SLUG=

# Export PATH
export PATH="/usr/local/bin:/usr/bin:$PATH"

response=$(curl -s -X GET --user $USERNAME:$PASSWORD "https://bitbucket.org/api/2.0/repositories/$REPO_OWNER/$REPO_SLUG/pullrequests/")
json=$(echo $response | jq '.values[] | {title: .title, author: .author.display_name, link: .links.html.href}')
prs=$(echo $response | jq '(.size|tostring) + " PRs"')

echo $prs | tr -d '"'
echo "---"
echo "View all PRs | href=https://bitbucket.org/blasttechnologies/arena/pull-requests/"
echo "---"

echo $json | jq '.author + " - " + .title + " | href=" + .link' | tr -d '"'
