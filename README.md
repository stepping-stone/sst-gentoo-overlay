stepping stone GmbH Gentoo Portage overlay
==========================================

This repository is stepping stone GmbH's official Portage overlay for Gentoo
systems.

Workflow
========

```
# Always use the branch `develop` for changing files:
git checkout develop
git add ...

# Update the metadata cache:
egencache --repo=stepping-stone --update
git add metadata/md5-cache

# Commit everything:
git commit -m ...

# Merge `develop` into `master`:
git checkout master
git merge --no-ff develop

# Push all changes
git push --all
```

Notes
=====

* we are using git-flow, please send pull-requests only against the develop branch
* we are using thin manifests (Manifest files contain only distfiles)
* we are not using ChangeLog files (use git for that)
* EAPI < 5 are banned
* Adhere to the Gentoo git workflow [commit message format](https://wiki.gentoo.org/wiki/Gentoo_git_workflow#Commit_message_format)
