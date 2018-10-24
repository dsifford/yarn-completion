# yarn-completion [![Build Status](https://travis-ci.com/dsifford/yarn-completion.svg?branch=master)](https://travis-ci.com/dsifford/yarn-completion)

> Bash ^4.x completion for [Yarn](https://github.com/yarnpkg/yarn)

## Installation

To enable on-demand completion loading, download the completion file to the predefined bash-completion user directory.

```sh
$ curl -o "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
```

### Installation on macOS with Homebrew

1.  `bash` version ^4.x.x is **required**.

    ```bash
    brew install bash

    # Add bash 4 to /etc/shells
    sudo echo /usr/local/bin/bash >> /etc/shells

    # Set bash 4 as your default login shell
    chsh -s /usr/local/bin/bash
    ```

2.  Install `bash-completion@2` if you have not done it yet:

    ```bash
    brew install bash-completion@2
    ## + copy one line to ~/.bash_profile as instructed by brew after bash-completion setup
    ```

3.  Install `yarn-completion`:

    ```sh
    mkdir -p "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
    curl -o "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
    ```

4.  Restart Terminal.

## FAQ

> Will you support bash 3?

**No**. Bash 3 is now 9 years outdated (at time of writing). There is no conceivable reason why anybody would or should still be using bash 3. Upgrade to bash 4.

> Completion fails for run scripts that contains a colon.

This is a feature of bash. Enable `menu-complete` in your `~/.inputrc` if you'd prefer a more seamless experience.

```
# Cycle through completions, rather than dumping all options
TAB:       menu-complete
"\e[Z":    menu-complete-backward
```

## License

MIT
