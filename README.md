# Bitbar Bitbucket Pull Requests plugin

A plugin for [BitBar](https://github.com/matryer/bitbar) that shows open pull requests for your [Bitbucket](https://bitbucket.org/) repository.

![](/screenshot.png?raw=true)

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

## License
MIT. See the License file for more info.