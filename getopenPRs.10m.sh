#!/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck source=/dev/null

# <bitbar.title>Bitbucket Pull Requests</bitbar.title>
# <bitbar.version>0.1</bitbar.version>
# <bitbar.author>Mikey Beck</bitbar.author>
# <bitbar.author.github>mikeybeck</bitbar.author.github>
# <bitbar.desc>Shows Bitbucket open pull request information</bitbar.desc>
# <bitbar.image>https://raw.githubusercontent.com/mikeybeck/bitbar-bitbucketPRs/master/screenshot.png</bitbar.image>
# <bitbar.dependencies>jq</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/mikeybeck/bitbar-bitbucketPRs</bitbar.abouturl>

# Relevant documentation for BitBucket: http://web.archive.org/web/20150530151816/https://confluence.atlassian.com/display/BITBUCKET/pullrequests+Resource#pullrequests

USERNAME=
PASSWORD=

REPO_OWNER=
REPO_SLUG=

# Export PATH
export PATH="/usr/local/bin:/usr/bin:$PATH"

response=$(curl -s -X GET --user $USERNAME:$PASSWORD "https://bitbucket.org/api/2.0/repositories/$REPO_OWNER/$REPO_SLUG/pullrequests/")
json=$(echo $response | jq '.values[] | {title: .title, author: .author.display_name, link: .links.html.href, status: .links.statuses.href}')
prs=$(echo $response | jq '(.size|tostring) + " PRs"')

echo $prs | tr -d '"'
echo "---"
echo "View all pull requests | href=https://bitbucket.org/$REPO_OWNER/$REPO_SLUG/pull-requests/"
echo "---"

for pr in $(echo "${json}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${pr} | base64 --decode | jq -r ${1}
    }

   build_state=$(curl -s -X GET --user $USERNAME:$PASSWORD $(_jq '.status') | jq -r '.values[].state')
   colour="red"
   if [[ $build_state == "SUCCESSFUL" ]]; then
		colour="green"
   fi

   echo $(_jq '.author') '-' $(_jq '.title') "| href=$(_jq '.link') color=$colour"

done
