#!/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck source=/dev/null

# <bitbar.title>Bitbucket Pull Requests</bitbar.title>
# <bitbar.version>1.0</bitbar.version>
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

NUM_APPROVALS_REQ=2  # Number of approvals required for pull request

# Export PATH
export PATH="/usr/local/bin:/usr/bin:$PATH"

response=$(curl -s -X GET --user $USERNAME:$PASSWORD "https://bitbucket.org/api/2.0/repositories/$REPO_OWNER/$REPO_SLUG/pullrequests/")

response=$(curl -s -X GET --user $USERNAME:$PASSWORD "https://bitbucket.org/api/2.0/repositories/$REPO_OWNER/$REPO_SLUG/pullrequests/")
json=$(echo $response | jq -r -c '[.values[] | {title: .title, author: .author.display_name, num_comments: .comment_count, link_html: .links.html.href, link_status: .links.statuses.href, link_self: .links.self.href}]')
prs=$(echo $response | jq '(.size|tostring) + " PRs"')

echo $prs | tr -d '"'
echo "---"
echo "View all open pull requests | href=https://bitbucket.org/$REPO_OWNER/$REPO_SLUG/pull-requests/"
echo "---"

for pr in $(echo "${json}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${pr} | base64 --decode | jq -r ${1}
    }

   build_state=$(curl -s -X GET --user $USERNAME:$PASSWORD $(_jq '.link_status') | jq -r '.values[].state')
   self=$(curl -s -X GET --user $USERNAME:$PASSWORD $(_jq '.link_self'))
   num_approvals=$(echo $self | jq -r '[select(.participants[].approved)] | length')
   colour="red"
   if [[ $build_state == "SUCCESSFUL" ]]; then
		colour="green" # Colour to show if PR is good to go (approved & build passed)
		if [ "$num_approvals" -lt "$NUM_APPROVALS_REQ" ]; then
			colour="black" # Colour to show if PR build passed but not approved
		fi
   fi

   echo $(_jq '.author') '-' $(_jq '.title') " ┃ :heavy_check_mark: $num_approvals ┃ :speech_balloon: $(_jq '.num_comments')" "| href=$(_jq '.link_html') color=$colour"

done
