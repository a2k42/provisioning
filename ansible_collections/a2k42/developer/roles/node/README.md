# Node and NVM Install

The install process was a little complex in terms of checking when installs have changed and knowing when to run an install. It could do with more testing to check that the conditionals are correct.

- [ ] Check installation conditionals

Output of nvm install

```bash
ok: [debian-base.local] =>
  msg: |-
    => Downloading nvm from git to '/home/test/.nvm'
    => * (HEAD detached at FETCH_HEAD)
      master
    => Compressing and cleaning up git repository

    => Appending nvm source string to /home/test/.bashrc
    => Appending bash_completion source string to /home/test/.bashrc
    => Close and reopen your terminal to start using nvm or run the following to use it now:

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
ok: [debian-kde.local] =>
  msg: |-
    => Downloading nvm from git to '/home/test/.nvm'
    => * (HEAD detached at FETCH_HEAD)
      master
    => Compressing and cleaning up git repository

    => Appending nvm source string to /home/test/.bashrc
    => Appending bash_completion source string to /home/test/.bashrc
    => Close and reopen your terminal to start using nvm or run the following to use it now:

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

> :warning: `community.general.npm` doesn't appear to work with `nvm` despite the documentation suggesting otherwise if the `environment` is set. This [stackoverflow](https://stackoverflow.com/questions/66494099/npm-module-not-working-with-nvm-in-ansible) question from a few years back ran into the same problem
