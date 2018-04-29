# Bitbar Bitbucket Pull Requests plugin

A plugin for [BitBar](https://github.com/matryer/bitbar) that shows open pull requests for your [Bitbucket](https://bitbucket.org/) repository.

![](/screenshot.png?raw=true)

Shows information about all open pull requests for any Bitbucket repository you have access to.

#### What is displayed?
- Name of PR submitter
- Title of PR
- Build status
- Number of approvals
- Number of comments

## Requirements
* [jq](https://stedolan.github.io/jq/)

## Installation
### Manually
```
bitbar://openPlugin?title=Bitbucket%20PRs&src=https://raw.githubusercontent.com/mikeybeck/bitbar-bitbucketPRs/blob/master/getopenPRs.10m.sh
```

## Settings
These are some settings that you will need to edit at the top of the `getopenPRs.10m.sh` file:

* `USERNAME` - Your Bitbucket username
* `PASSWORD`- Your Bitbucket password
* `REPO_OWNER`- Owner of the Bitbucket repository
* `REPO_SLUG`- Slug of the Bitbucket repository

### TODO

- [x] Display build status for PR (red & green colour coded - at the cost of speed.)
- [x] Display number of approvals (also slows things down due to extra http call.)
- [x] Display number of comments
- [ ] Make build status display / number of approvals / number of comments optional
- [x] Use icons to indicate comments / approvals
- [ ] Put one user's (i.e. your own) PRs into a separate section

## License
MIT. See the License file for more info.